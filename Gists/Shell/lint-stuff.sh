find terraform -type d -mindepth 1 -maxdepth 1 | \
		xargs -I {} bash -c "cd {} && terraform init -backend=false && terraform validate"


find . -type f -name "*.tf" | xargs dirname | sort -u | \
		xargs -I {} bash -c "cd {} && tflint --disable-rule=terraform_typed_variables || true"


find . -type f -name "*.py" -exec pylint {} + || true


find . -type f -name "*Dockerfile*" -exec hadolint {} + || true
