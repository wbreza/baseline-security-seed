#!/bin/bash
set -euo pipefail

parent_path=$(
    cd "$(dirname "${BASH_SOURCE[0]}")"
    pwd -P
)

current_path=$(pwd -P)

cd "$parent_path"

echo "Changing owner on .git/hooks directory..."
sudo chown codespace -R ../../.git/hooks

echo 'Creating python virtual environment...'
python -m venv ../.venv
sudo chown codespace -R ../.venv

echo 'Activating python virtual environment...'

if [ "$(uname)" == "Darwin" ]; then
    . ../.venv/bin/activate
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    . ../.venv/bin/activate
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    . ../.venv/scripts/activate
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    . ../.venv/scripts/activate
fi

echo "Configuring Git pre-commit hooks..."
. ./init-repo.sh

oryx build -p virtualenv_name=.venv --log-file /tmp/oryx-build.log --manifest-dir /tmp || echo 'Could not auto-build. Skipping.'

cd "$current_path"
