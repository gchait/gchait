#!/bin/bash

group_name=xxx
new_role_arn=xxx

spotinst_account=xxx
spotinst_token=xxx

generate_put_data()
{
  cat <<EOF
{
    "group": {
        "compute": {
            "launchSpecification": {
                "iamRole": {
                    "arn": "${new_role_arn}"
                }
            }
        }
    }
}
EOF
}

sig=$(curl -s -H "Authorization: Bearer ${spotinst_token}" \
      "https://api.spotinst.io/aws/ec2/group?accountId=${spotinst_account}&name=${group_name}" | \
      grep sig- | awk '{print $2}' | tr -d '\",')

curl -s -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer ${spotinst_token}" \
     -d "$(generate_put_data)" "https://api.spotinst.io/aws/ec2/group/${sig}?accountId=${spotinst_account}"
