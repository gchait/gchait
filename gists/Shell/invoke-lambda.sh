aws lambda invoke \
    --function-name my-func \
    --payload '{"hello": "world"}' \
    --cli-binary-format raw-in-base64-out \
    /dev/stdout
