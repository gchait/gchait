def ec2_instance_types(region):
    """Yields all available EC2 instance types in the specified region."""
    ec2 = boto3.client("ec2", region_name=region)
    describe_args = {}

    while True:
        describe_result = ec2.describe_instance_types(**describe_args)
        yield from [i["InstanceType"] for i in describe_result["InstanceTypes"]]
        if "NextToken" not in describe_result:
            break
        describe_args["NextToken"] = describe_result["NextToken"]


def validate_ec2_instance_type(instance_type):
    """Ensures the instance type provided is an actual instance type."""
    if instance_type not in ec2_instance_types(region):
        fail(f'Invalid instance type: "{instance_type}".', 2)
