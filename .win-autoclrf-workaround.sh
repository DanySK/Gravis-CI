#!/bin/bash
echo Work around script for autoclrf setting on Windows under Travis CI
if [ $TRAVIS_OS_NAME = 'windows' ]
then
    echo working around bad Windows autoclrf setting on Travis
    git config --global core.autocrlf false
    git config core.autocrlf false
    git rm --cached -r .
    git reset --hard
else
    echo Environment $TRAVIS_OS_NAME does not need any action
fi
