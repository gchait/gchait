async def instance_type_to_cpu_mem(
    region: str, instance_type: str
) -> Optional[tuple[int, int]]:
    """Translate an EC2/RDS instance type to CPUs and Memory."""
    client = ec2_clients[region]
    if instance_type.startswith("db."):
        instance_type = instance_type.removeprefix("db.")

    try:
        ec2_response = client.describe_instance_types(InstanceTypes=[instance_type])
        matched_type = ec2_response["InstanceTypes"][0]

        cpu = matched_type["VCpuInfo"]["DefaultVCpus"]
        mem = int(matched_type["MemoryInfo"]["SizeInMiB"] / 1024)
        return cpu, mem

    except (KeyError, IndexError):
        return None
