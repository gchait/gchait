export PROD_HOST := "guyc.at"
export REPO := "gchait/guyc-at"
export SRC := "guyc_at"
export PORT := "3000"

fmt:
    dart format {{SRC}}
    dart fix --apply {{SRC}}

lint:
    dart analyze {{SRC}}

test:
    cd {{SRC}} && dart test

dev: fmt lint
    docker compose build
    docker compose up -d

prod:
    docker compose pull
    SITE_ADDRESS={{PROD_HOST}} docker compose up -d

push MSG: test
    docker compose build --push
    git add -A
    git commit -m "{{MSG}}"
    git push origin

prune:
    docker image prune -f

deploy:
    ssh prod "cd guyc-at && git pull && just prod prune"

cert:
    docker compose cp caddy:/data/caddy/pki/authorities/local/root.crt .
