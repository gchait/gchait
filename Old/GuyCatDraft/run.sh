#!/bin/sh -ex

uvicorn guyc_at.main:app \
    --no-server-header \
    --proxy-headers \
    --forwarded-allow-ips '*' \
    --host '0.0.0.0' \
    --port "${PORT}"
