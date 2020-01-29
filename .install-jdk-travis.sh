#!/bin/bash
install_jdk () {
    if $jabba use $ACTUAL_JDK; then
        echo $ACTUAL_JDK was available and Jabba is using it
    else
        echo installing $ACTUAL_JDK
        $jabba install "$ACTUAL_JDK" || exit $?
        echo setting $ACTUAL_JDK as Jabba default
        $jabba use $ACTUAL_JDK || exit $?
    fi
}

unix_pre () {
    curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | bash && . ~/.jabba/jabba.sh
    unset _JAVA_OPTIONS
    export jabba=jabba
}

install_jabba_on_linux () {
    unix_pre
}

install_jabba_on_osx () {
    unix_pre
    export JAVA_HOME="$HOME/.jabba/jdk/$ACTUAL_JDK/Contents/Home"
}

install_jabba_on_windows () {
    PowerShell -ExecutionPolicy Bypass -Command '[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-Expression (Invoke-WebRequest https://github.com/shyiko/jabba/raw/master/install.ps1 -UseBasicParsing).Content'
    export jabba="$HOME/.jabba/bin/jabba.exe"
}

complete_installation_on_linux () {
    echo 
}

complete_installation_on_osx () {
    export JAVA_HOME="$HOME/.jabba/jdk/$ACTUAL_JDK/Contents/Home"
}

complete_installation_on_windows () {
    # Windows is unable to clean child processes, so no Gradle daemon allowed
    export GRADLE_OPTS="-Dorg.gradle.daemon=false $GRADLE_OPTS"
    echo 'export GRADLE_OPTS="-Dorg.gradle.daemon=false $GRADLE_OPTS"' >> ~/.jdk_config
}

set -e
if [ -z $JDK ]
then
    echo "No JDK variable provided."
    exit 1
fi
echo "running ${TRAVIS_OS_NAME}-specific configuration"
echo "installing Jabba"
install_jabba_on_$TRAVIS_OS_NAME
echo "Computing best match for required JDK version: $JDK"
ACTUAL_JDK="$(echo $($jabba ls-remote | grep -m1 $JDK))"
echo "Selected JDK: $ACTUAL_JDK"
if [ -z $ACTUAL_JDK ]
then
    echo "No JDK version is compatible with $JDK. Available JDKs are:"
    "$jabba" ls-remote
    exit 2
else
    echo "Best match is $ACTUAL_JDK"
    export JAVA_HOME="$HOME/.jabba/jdk/$ACTUAL_JDK"
    complete_installation_on_$TRAVIS_OS_NAME
    export PATH="$JAVA_HOME/bin:$PATH"
    # Apparently exported variables are ignored in subseguent phases on Windows. Write in config file
    echo "export JAVA_HOME=\"${JAVA_HOME}\"" >> ~/.jdk_config
    echo "export PATH=\"${PATH}\"" >> ~/.jdk_config
    install_jdk
    which java
    java -Xmx32m -version
    set +e
fi
