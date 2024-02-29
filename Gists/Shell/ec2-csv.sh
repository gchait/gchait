aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running,stopped,stopping,shutting-down" \
  --query 'Reservations[].Instances[].{Name: Tags[?Key==`Name`].Value | [0], xxx: Tags[?Key==`xxx`].Value | [0], InstanceId: InstanceId, State: State.Name, Type: InstanceType}' \
  --output json | python -c 'import sys,pandas as pd;pd.read_json(sys.stdin).to_csv("ec2.csv", encoding="utf-8", index=False)'
