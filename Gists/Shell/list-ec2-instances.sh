aws ec2 describe-instances --region xx-xxxxx-n --output text \
    --query 'Reservations[].Instances[].[Tags[?Key==`Name`] | [0].Value, State.Name]'
