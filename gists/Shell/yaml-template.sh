#!/usr/bin/env bash

yq --help &> /dev/null || { echo yq is required! && exit 2; }

sedi=(-i)
case "$(uname)" in
  Darwin*) sedi=(-i "")
esac

cd "$(dirname "$0")" || exit 1

cp -R templates "${YYYYYYYY}" 2> /dev/null || { echo Please set YYYYYYYY! && exit 2; }
required_vars=$(grep -ERIoh "__[A-Z1-9_]+__" templates | sort -u | sed "s/__//g")

for var in ${required_vars}; do
    if [ -z "${!var}" ]; then
        echo "${var} is required but not set!"
        exit 1
    else
        grep -RIl "__${var}__" "${YYYYYYYY}" | xargs sed "${sedi[@]}" -e "s|__${var}__|${!var}|g"
    fi
done

if [ -d "XXXXXX/${YYYYYYYY}" ]; then
    cd "${YYYYYYYY}" || exit 1

    for f in *.yaml; do
        [[ ${f} = "ZZZZZZ" ]] && continue

        yq eval-all --inplace 'select(fileIndex == 0) *d select(fileIndex == 1)' \
            "../XXXXXX/${YYYYYYYY}/${f}" "${f}"
    done

    cd ../
    rm -rf "${YYYYYYYY}"

else
    mv "${YYYYYYYY}" XXXXXX/
fi

echo Done!
