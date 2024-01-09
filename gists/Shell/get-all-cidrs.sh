# Use this only from workstations.
# Make sure you can authenticate with all profiles first, as this script hides all errors!
# To show only the information collected, run this with "2> /dev/null".

profiles=$(grep -Eo "^\[profile (.+)\]$" ~/.aws/config | cut -d" " -f2 | tr -d "]")
regions="XXX XXX XXX"
output=""

for profile in $profiles; do
    for region in $regions; do
        echo "Checking $region in $profile..." >&2
        output+=$(aws ec2 describe-vpcs --output text --query "Vpcs[*].[CidrBlock]" \
                  --region "$region"  --profile "$profile" 2> /dev/null)
        output+="\n"
    done
done

echo >&2
echo "Results:" >&2
echo -e "$output" | sort | grep --color=never .
