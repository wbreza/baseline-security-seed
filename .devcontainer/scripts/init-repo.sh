#!/bin/bash
set -euo pipefail

parent_path=$(
    cd "$(dirname "${BASH_SOURCE[0]}")"
    pwd -P
)
cd "$parent_path"

echo -n 'Creating python virtual environment...'
python -m venv ../.venv
echo 'done'

echo -n 'Activating python virtual environment...'

if [ "$(uname)" == "Darwin" ]; then
    . ../.venv/bin/activate
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    . ../.venv/bin/activate
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    . ../.venv/scripts/activate
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    . ../.venv/scripts/activate
fi

echo 'done'

echo 'Installing repo dependencies...'
pip install -r ../requirements.txt

echo -n 'Installing pre-commit hooks for first time setup...'
pre-commit install
pre-commit run --all-files
