#!/bin/bash
set -e
MIRROR="https://archive.apache.org/dist/maven/maven-3/"
echo "Fetching the latest available Maven from $MIRROR"
LATEST_MAVEN=$( curl $MIRROR | python -c "
import re
import sys
versions = [
  match
  for line in sys.stdin.readlines()
  for match in re.findall(r'.*href=\"(\d+\.\d+\.\d+)\/\">', line)
]
print(max(versions))
" )
echo "Latest available version is $LATEST_MAVEN"
MAVEN_VERSION=${MAVEN_VERSION:-$LATEST_MAVEN}
echo "Installing Maven ${MAVEN_VERSION} on ${TRAVIS_OS_NAME}"
MAVEN_INSTALL_FOLDER="${HOME}"
echo "Creating ${MAVEN_INSTALL_FOLDER}"
mkdir -p $MAVEN_INSTALL_FOLDER
MAVEN_TARBALL="apache-maven-${MAVEN_VERSION}-bin.tar.gz"
MAVEN_DOWNLOAD_URL="${MIRROR}${MAVEN_VERSION}/binaries/${MAVEN_TARBALL}"
echo "Downloading Maven ${MAVEN_VERSION} from ${MAVEN_DOWNLOAD_URL} into ${MAVEN_INSTALL_FOLDER}"
MAVEN_INSTALLER_LOCATION="${MAVEN_INSTALL_FOLDER}/${MAVEN_TARBALL}"
curl -sL $MAVEN_DOWNLOAD_URL --output $MAVEN_INSTALLER_LOCATION
echo "Unpacking ${MAVEN_INSTALLER_LOCATION}..."
tar xzvf "${MAVEN_INSTALLER_LOCATION}" --directory="${MAVEN_INSTALL_FOLDER}"
echo "Updating PATH..."
export PATH="$MAVEN_INSTALL_FOLDER/apache-maven-${MAVEN_VERSION}/bin:$PATH"
echo "Testing maven version"
mvn -v
set +e
