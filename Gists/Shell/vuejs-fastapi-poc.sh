#!/bin/sh -xe

cd "$(dirname ${0})"

python3 -m venv /tmp/.venv
. /tmp/.venv/bin/activate
pip3 install -r ./reqs.dev.txt -r ./reqs.txt

isort .
black .
flake8 .
pylint .
bandit -r .

docker run -it --rm --name web-test \
    -e PYTHONDONTWRITEBYTECODE=1 -e PYTHONUNBUFFERED=1 \
    -p 8080:8080 -v .:/app -w /app python:3-alpine \
    sh -c "pip install -r ./reqs.txt && python ./app.py"
