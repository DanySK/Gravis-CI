#!/bin/bash
if [ $TRAVIS_OS_NAME = "windows"]
then
    echo working around bad Windows autoclrf setting on Travis
    git config --global core.autocrlf false
    git config core.autocrlf false
    git rm --cached -r .
    git reset --hard
fi
