#!/bin/bash
# This script requires pyenv to be setup.
# The PYTHON environment variable must be set to the desired Python version, or the latest stable will be used
set -e
LATEST_PYTHON_STABLE=$(pyenv install -l | awk '{$1=$1};1' | sort -r | grep -E '^([0-9]*\.)*[0-9]*$' -m 1)
echo "The latest version available on pyenv is $LATEST_PYTHON_STABLE"
PYTHON="${PYTHON:-$LATEST_PYTHON_STABLE}"
echo "Python version selected: $PYTHON"
echo "Installing Python $PYTHON..."
pyenv install --skip-existing $PYTHON
echo "...done. Setting global to ${PYTHON}..."
pyenv global $PYTHON
echo "...done. Checking version."
python --version
set +e
