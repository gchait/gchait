k get node | FILTER HERE | grep -v NAME | awk '{print $1}' | \
    xargs -I {} kubectl get node -o yaml {} | grep providerID | grep -Eo "i-.+$" | \
    xargs -I {} aws ec2 terminate-instances --instance-ids {} --region xx-xxxxx-n

# Now we can just do k delete node :)
