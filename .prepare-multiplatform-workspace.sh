#!/bin/bash
CACHED_BUILD_FOLDER=${1:-$TRAVIS_BUILD_DIR/build}
echo "saving data of $CACHED_BUILD_FOLDER"
# Prepare replacement
TO_REPLACE=$(echo $HOME | sed "s:/:\\\\/:g")
# Prepare workspace for Windows and OSX
WIN_HOME="/c/Users/$USER"
OSX_HOME="/Users/$USER"
WIN_FOLDER=$(echo "$CACHED_BUILD_FOLDER" | sed "s:$TO_REPLACE*:$WIN_HOME:")
echo destination copy folder for Windows: $WIN_FOLDER
OSX_FOLDER=$(echo "$CACHED_BUILD_FOLDER" | sed "s:$TO_REPLACE*:$OSX_HOME:")
echo destination copy folder for OSX $OSX_FOLDER
sudo mkdir -p $WIN_FOLDER
sudo mkdir -p $OSX_FOLDER
sudo chown $USER $WIN_FOLDER
sudo chown $USER $OSX_FOLDER
cp -R "$CACHED_BUILD_FOLDER"/* $WIN_FOLDER
cp -R "$CACHED_BUILD_FOLDER"/* $OSX_FOLDER
