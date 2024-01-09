async def extract_resource_tags(resource: dict) -> CaseInsensitiveDict:
    """Extract the tags of an AWS resource. Was tested on RDS and EC2 instances."""
    tag_list = resource.get("TagList", resource.get("Tags", []))
    result = CaseInsensitiveDict()

    for tag in tag_list:
        result[tag["Key"]] = tag["Value"] or "null"
    return result


async def get_volume_sizes(region: str, volume_ids: list) -> list[int]:
    """Because EC2 instances contain only volume IDs."""
    ebs_volumes = ec2_clients[region].describe_volumes(VolumeIds=volume_ids)["Volumes"]
    return [ebs["Size"] for ebs in ebs_volumes if "Size" in ebs]


async def get_raw_ec2_instances(
  region: str, **tags_filter
) -> AsyncGenerator[dict, None]:
  """A raw lookup into instances in the EC2 API."""
  filtered_ec2_instances = ec2_clients[region].describe_instances(
      Filters=[
          {"Name": f"tag:{key}", "Values": [value]}
          for key, value in tags_filter.items()
      ]
  )

  for reservation in filtered_ec2_instances["Reservations"]:
      for instance in reservation["Instances"]:
          yield instance
          