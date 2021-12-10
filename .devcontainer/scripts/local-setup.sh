#!/bin/bash
set -euo pipefail

parent_path=$(
    cd "$(dirname "${BASH_SOURCE[0]}")"
    pwd -P
)

current_path=$(pwd -P)

echo $current_path

cd "$parent_path"

. ./python-virtualenv.sh
. ./init-repo.sh

cd "$current_path"