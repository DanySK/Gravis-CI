#!/bin/bash
curl -s "https://get.sdkman.io" | bash
source ~/.bash_profile
sdk install kotlins
sdk install kscript
kscript --help
