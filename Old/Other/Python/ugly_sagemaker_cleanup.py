#!/usr/bin/env python3

from subprocess import run
from random import shuffle

REGION = "xxx"
TAG = "xxx"
TRIES = 2


def print_sagemaker_arns(arns, failed=False):
    if failed:
        print("This script is not perfect, these resources still remain in the Resource Groups Tagging API:")
        print("(But maybe they were already deleted in reality:")
        print("https://repost.aws/questions/QUcinjyU36SBSmcYA8eYJf0Q/"
              "only-get-existing-resources-with-resource-group-tagging-api")
        print("https://stackoverflow.com/questions/71035336/only-get-existing-resources-with-resourcegrouptaggingapi)")
    else:
        print("Discovered these SageMaker resources:")

    for arn in arns:
        print(arn)


def disassociate_sagemaker_resources(arns):
    for x in arns:
        for y in reversed(arns):
            p = run(
                f"aws sagemaker delete-association --region {REGION} --destination-arn {x} --source-arn {y} && sleep 1",
                shell=True, capture_output=True, text=True
            )

            if p.stderr:
                print(p.stderr)


def delete_sagemaker_resource(resource_type, resource_name):
    p = run(
        f"aws sagemaker delete-{resource_type} --region {REGION} --{resource_type}-name {resource_name}",
        shell=True, capture_output=True, text=True
    )

    if p.stderr:
        print(p.stderr)
    return p.stdout


def filter_arns_by_type(arns, resource_type):
    return (
        {
            "arn": arn,
            "name": arn.split("/")[1]
        }
        for arn in arns if f":{resource_type}/" in arn
    )


def discover_sagemaker_resources():
    arns = run(
        (f"aws resourcegroupstaggingapi get-resources --region {REGION} --tag-filters "
         f"Key=TAG,Values={TAG} --query 'ResourceTagMappingList[].ResourceARN' | "
         "grep ':sagemaker:' | tr -d '\",' | awk '{print $1}' | sort"),
        shell=True, capture_output=True, text=True
    ).stdout.splitlines()

    endpoints = filter_arns_by_type(arns, "endpoint")
    endpoint_configs = filter_arns_by_type(arns, "endpoint-config")
    models = filter_arns_by_type(arns, "model")
    actions = filter_arns_by_type(arns, "action")
    contexts = filter_arns_by_type(arns, "context")

    return arns, endpoints, endpoint_configs, models, actions, contexts


def main():
    for _ in range(TRIES):
        arns, endpoints, endpoint_configs, models, actions, contexts = discover_sagemaker_resources()

        print_sagemaker_arns(arns)
        shuffle(arns)

        print("Disassociating resources...")
        disassociate_sagemaker_resources([a["arn"] for a in actions] + [c["arn"] for c in contexts])

        print("Deleting endpoints...")
        for e in endpoints:
            delete_sagemaker_resource("endpoint", e["name"])

        print("Deleting endpoint configurations...")
        for ep in endpoint_configs:
            delete_sagemaker_resource("endpoint-config", ep["name"])

        print("Deleting models...")
        for m in models:
            delete_sagemaker_resource("model", m["name"])

        print("Deleting actions...")
        for a in actions:
            delete_sagemaker_resource("action", a["name"])

        print("Deleting contexts...")
        for c in contexts:
            delete_sagemaker_resource("context", c["name"])

    arns = discover_sagemaker_resources()[0]
    if arns:
        print_sagemaker_arns(arns, failed=True)
    else:
        print("Success!")


if __name__ == "__main__":
    main()
