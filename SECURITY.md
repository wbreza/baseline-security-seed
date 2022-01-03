# Security

## Secret Detection

Secret Detection aims to prevent the unintentional leak of sensitive information including: passwords, authentication tokens, and private keys. It checks source files and configuration files to detect well-known and common patterns that look like secrets or credentials and reports findings that are potentially risky to share.

### Goal

Overall we want to help developers write better code and worry less about common security mistakes. Our goal is to provide Secret Detection as a part of the standard software development lifecycle (SDLC). This means that Secret Detection is executed every time a new commit is pushed to a branch.

This package is designed with the enterprise client in mind: providing a backwards compatible, systematic means of:

- Preventing new secrets from entering the code base,
- Detecting if such preventions are explicitly bypassed, and
- Providing a checklist of secrets to roll, and migrate off to a more secure storage.

This repo is configured to detect secrets at multiple levels

1. At **development** time via git pre-commit hooks
1. At **review time** via GitHub actions for all pull requests

## Prerequisites

The following components are required to be pre-installed when developing locally.

1. [Visual Studio Code](https://code.visualstudio.com/Download)
1. [Python version 3.8](https://www.python.org/downloads/)

> You can optionally open this repo in a [VS Code remote container](https://code.visualstudio.com/docs/remote/containers) OR [GitHub Codespace](https://github.com/features/codespaces).

## Setup

The baseline security supports 2 modes of development. Developing Locally and using Dev Containers or Codespaces.

### Developing Locally

Git pre-commit hooks require setup before they can start working as designed.
To streamline this process run the following:

The pre-commit framework and detect secrets tooling requires Python

```bash
# Initialize and setup local environment
. .devcontainer/scripts/local-setup.sh
```

> Don't forget the *space* between the dots above

The `local-setup.sh` script performs the following:

1. Creates and activates a [Python virtual environment](https://docs.python.org/3.8/library/venv.html)
1. Installs python package dependencies via [pip](https://pip.pypa.io/en/stable/)
   - [pre-commit](https://github.com/pre-commit/pre-commit) - For git pre-commit hook framework
   - [detect-secrets](https://github.com/Yelp/detect-secrets) - Package developed by Yelp! for secret detection
1. Configures pre-commits hooks from the `.pre-commit-config.yaml` config file.
1. Runs all hooks to create an initial baseline check

### Using Dev Container / Codespace

Good news! The dev container is automatically configured and runs the setup scripts as part of the dev container `postCreateCommand`. You repo will automatically be protected and secure.

## Running Secret Scanning

After following the [setup](#Setup) section secret scanning will automatically run before all local commits.
If a secret is detected it will fail your commit and alert you of the detected secrets.

For more information of configuring secret detection review the [usage](https://github.com/Yelp/detect-secrets#usage) guidelines in the detect-secrets repo.

### Blocking Secrets not in Baseline

You can manually detect secrets outside of the pre-commit hook by running the following commands:

#### Scanning Staged files only

```bash
git diff --staged --name-only -z | xargs -0 detect-secrets-hook --baseline .secrets.baseline
```

> This command is similar to what is run by the pre-commit hook to ensure currently staged files do not contain and secrets.

#### Scanning all tracked files

```bash
git ls-files -z | xargs -0 detect-secrets-hook --baseline .secrets.baseline
```

> This is the command that is run as part of the GitHub action to catch any secrets that slip through pre-commit hooks

### Adding Secrets to Baseline

There are occasions where the tooling may catch a false positive.
If this occurs you can perform the following:

#### Scans repo and adds new secrets

```bash
detect-secrets scan --baseline .secrets.baseline
```

> For more information refer to the [official docs](https://github.com/Yelp/detect-secrets#adding-secrets-to-baseline)

### Auditing Secrets in Baseline

Auditing a baseline allows analysts to label results, and optimize plugins for
the highest signal-to-noise ratio for their environment.

```bash
detect-secrets audit .secrets.baseline
```

> For more information refer to the [official docs](https://github.com/Yelp/detect-secrets#auditing-secrets-in-baseline)
