#!/bin/bash -ex

set -o allexport
source .env
set +o allexport

cluster_args="--cluster ${ECS_CLUSTER} --region ${REGION}"
net_config="{\"awsvpcConfiguration\":{\"assignPublicIp\":\"XXX\",\"subnets\":[\"${SUBNET_ID}\"]}}"

task_arn=$(aws ecs run-task ${cluster_args} \
    --task-definition "${ECS_TASK_DEF_ARN}" --launch-type FARGATE \
    --network-configuration "${net_config}" \
    --query 'tasks[].taskArn')

aws ecs wait tasks-running ${cluster_args} --tasks "${task_arn}"
aws ecs wait tasks-stopped ${cluster_args} --tasks "${task_arn}"
