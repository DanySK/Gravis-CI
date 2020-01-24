#!/bin/bash
# This script requires pyenv to be setup.
# The PYTHON environment variable must be set to the desired Python version, or the latest stable will be used
set -e
echo "Running pyenv post-install fix"
echo "Setting PYENV_ROOT to $HOME/.pyenv if it is undefined"
# From pyenv suggested installation, as homebrew does not seem to complete the installation correctly
echo 'export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"' >> ~/.bash_profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bash_profile
source ~/.bash_profile
echo "PYENV_ROOT is now $PYENV_ROOT"
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
pyenv versions
echo "Setting global to ${PYTHON}..."
pyenv global $PYTHON
echo "...done. Checking version."
pyenv versions
echo "python -V: $(python -V)"
echo "pip -V: $(pip -V)"
echo "Python is set to $(which python)"
echo "pip is set to $(which pip)"
set +e
