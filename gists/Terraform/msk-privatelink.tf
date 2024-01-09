locals {
  broker_fqdns = [for broker in split(",", aws_msk_cluster.kafka.bootstrap_brokers_tls) :
  trimsuffix(broker, ":${var.msk_port}")]

  broker_addrs = { for broker in data.dns_a_record_set.brokers : broker.addrs[0] => broker.host }

  pl_relevant_enis = (var.enable_privatelink ? [for eni in data.aws_network_interface.brokers :
    merge({ public_fqdn = local.broker_addrs[eni["private_ip"]] }, eni)
  if contains(keys(local.broker_addrs), eni["private_ip"])] : [])

  az_map = { for i in range(length(data.aws_availability_zones.available.names)) :
  data.aws_availability_zones.available.names[i] => data.aws_availability_zones.available.zone_ids[i] }

  pl_json = var.enable_privatelink ? jsonencode({
    dns_zone_name = "kafka.${var.region}.amazonaws.com"
    brokers = [
      for svc in aws_vpc_endpoint_service.privatelink : {
        zone_id  = local.az_map[tolist(svc.availability_zones)[0]]
        vpce_svc = svc.service_name
        hostname = svc.tags["BrokerFqdn"]
      }
    ]
  }) : null
}

resource "aws_lb" "brokers" {
  count = var.broker_count
  name  = "XXXXX-${trimprefix(split(".", local.pl_relevant_enis[count.index]["public_fqdn"])[0], "b-")}"

  internal = true
  subnets  = [local.pl_relevant_enis[count.index]["subnet_id"]]

  load_balancer_type               = "network"
  enable_deletion_protection       = XXXXX
  enable_cross_zone_load_balancing = false

  tags = {
    BrokerFqdn = local.pl_relevant_enis[count.index]["public_fqdn"]
  }
}

resource "aws_lb_target_group" "brokers" {
  count = var.broker_count
  name  = "XXXXX-${trimprefix(split(".", local.pl_relevant_enis[count.index]["public_fqdn"])[0], "b-")}"
  port  = var.msk_port

  protocol    = XXXXX
  target_type = XXXXX
  vpc_id      = var.vpc_id

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_lb_target_group_attachment" "brokers" {
  count            = var.broker_count
  target_group_arn = aws_lb_target_group.brokers[count.index].arn
  target_id        = local.pl_relevant_enis[count.index]["private_ip"]
}

resource "aws_lb_listener" "brokers" {
  count             = var.broker_count
  load_balancer_arn = aws_lb.brokers[count.index].arn
  port              = var.msk_port
  protocol          = xxxxx

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.brokers[count.index].arn
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_vpc_endpoint_service" "privatelink" {
  count                      = length(aws_lb.brokers)
  acceptance_required        = XXXXX
  network_load_balancer_arns = [aws_lb.brokers[count.index].arn]
  allowed_principals         = [XXXXX]

  tags = {
    Name       = "XXXXX-${trimprefix(split(".", aws_lb.brokers[count.index].tags["BrokerFqdn"])[0], "b-")}"
    BrokerFqdn = aws_lb.brokers[count.index].tags["BrokerFqdn"]
  }
}

variable "broker_count" {}
variable "msk_port" {}
variable "vpc_id" {}
variable "enable_privatelink" {}
variable "region" {}
