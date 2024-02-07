#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
REPO_ROOT="$(realpath $SCRIPT_DIR/..)"

cd "$REPO_ROOT"

sha512sum \
    .gitlab-ci/generate-ci-configs.sh \
    Blatt*/praxis/Aufgabe*/Makefile \
    tools/*.mk tools/ROrgPrSimLib++/prepare.sh \
    tools/ROrgPrSimLib++/libROrgPrSimLib*.so \
    tools/ROrgPrSimLib++/vhdl/* \
    | gpg --clear-sign > .gitlab-ci/hashes.txt
