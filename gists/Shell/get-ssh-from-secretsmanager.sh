aws secretsmanager get-secret-value --secret-id SECRET_NAME --query 'SecretString' --output text \
    | jq -r '.JSON_FIELD' | base64 -d > ~/.ssh/id_rsa && chmod 400 ~/.ssh/id_rsa
