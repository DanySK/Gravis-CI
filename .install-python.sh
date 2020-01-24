#!/bin/bash
# This script requires pyenv to be setup.
# The PYTHON environment variable must be set to the desired Python version, or the latest stable will be used
set -e
echo "Running pyenv post-install fix"
echo "Forcing PYENV_ROOT to $HOME/.pyenv to allow for caching"
export PYENV_ROOT="$HOME/.pyenv"
echo "PYENV_ROOT is now $PYENV_ROOT"
echo "Appending PYENV_ROOT in front of PATH"
export PATH="$PYENV_ROOT:$PATH"
echo "PATH is now $PATH"
echo "Initialize pyenv shims"
eval "$(pyenv init -)"
echo "PATH is now $PATH"
LATEST_PYTHON_STABLE=$(pyenv install -l | awk '{$1=$1};1' | sort -r | grep -E '^([0-9]*\.)*[0-9]*$' -m 1)
echo "Done. Now installing Python."
echo "The latest version available on pyenv is $LATEST_PYTHON_STABLE"
PYTHON="${PYTHON:-$LATEST_PYTHON_STABLE}"
echo "Python version selected: $PYTHON. Installing..."
pyenv install --skip-existing $PYTHON
echo "...done. Setting global to ${PYTHON}..."
pyenv global $PYTHON
echo "...done. Checking version."
echo "python -V: $(python -V)"
echo "pip -V: $(pip -V)"
echo "Python is set to $(which python)"
echo "pip is set to $(which pip)"
set +e
