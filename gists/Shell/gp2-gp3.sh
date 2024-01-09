regions=$($AWS ec2 describe-regions --output text | cut -f4)

for region in ${regions}; do
    echo "------------------------------------"
    echo "Iterating over region $region ..."

    # shellcheck disable=SC2016
    volume_ids=$($AWS ec2 describe-volumes --region "$region" --filters Name=volume-type,Values=gp2 --output text \
                 --query 'Volumes[?Size <= `1000`].VolumeId')

    if [ "${volume_ids}" == "" ]; then
        echo "No volumes found."
    else
        echo
    fi

    for volume_id in ${volume_ids}; do
        # This is a dummy result, when you actually want to modify the volumes, please comment this:
        result="modifying"
        # And uncomment this:
#        result=$($AWS ec2 modify-volume --region "${region}" --volume-type=gp3 \
#                 --volume-id "${volume_id}" | jq '.VolumeModification.ModificationState' | tr -d '"')

        # shellcheck disable=SC2181
        if [ $? -eq 0 ] && [ "${result}" == "modifying" ]; then
            echo "OK: Volume ${volume_id} changed its to state to 'modifying'."

        else
            echo "ERROR: Couldn't change the type of volume ${volume_id} to gp3!"
        fi
    done
done
echo "------------------------------------"