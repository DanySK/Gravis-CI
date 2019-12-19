#!/bin/bash
set -e
MAVEN_VERSION=${MAVEN_VERSION:-3.6.1}
echo "Installing Maven ${MAVEN_VERSION} on ${TRAVIS_OS_NAME}"
MAVEN_INSTALL_FOLDER="${HOME}"
echo "Creating ${MAVEN_INSTALL_FOLDER}"
mkdir -p $MAVEN_INSTALL_FOLDER
MAVEN_TARBALL="apache-maven-${MAVEN_VERSION}-bin.tar.gz"
MAVEN_DOWNLOAD_URL="https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/${MAVEN_TARBALL}"
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
