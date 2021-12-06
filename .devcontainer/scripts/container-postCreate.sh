#!/bin/bash
set -euo pipefail

parent_path=$(
    cd "$(dirname "${BASH_SOURCE[0]}")"
    pwd -P
)

current_path=$(pwd -P)

cd "$parent_path"

# echo "Changing owner on .git/hooks directory..."
# sudo chown codespace -R ./.git/hooks

echo "Configuring Git pre-commit hooks..."
. ./init-repo.sh

cd "$current_path"