#!/bin/bash
install_jdk () {
    if $jabba use $JDK; then
        echo $JDK was available and Jabba is using it
    else
        echo installing $JDK
        $jabba install "$JDK"
        echo setting $JDK as Jabba default
        $jabba use $JDK
    fi
}

unix_pre () {
    curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | bash && . ~/.jabba/jabba.sh
    unset _JAVA_OPTIONS
    export jabba=jabba
}

linux () {
    unix_pre
    export JAVA_HOME="$HOME/.jabba/jdk/$JDK"
    export PATH="$JAVA_HOME/bin:$PATH"
}

osx () {
    unix_pre
    export JAVA_HOME="$HOME/.jabba/jdk/$JDK/Contents/Home"
    export PATH="$JAVA_HOME/bin:$PATH"
}

windows () {
    PowerShell -ExecutionPolicy Bypass -Command '[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-Expression (Invoke-WebRequest https://github.com/shyiko/jabba/raw/master/install.ps1 -UseBasicParsing).Content'
    export jabba="$HOME/.jabba/bin/jabba.exe"
    export JAVA_HOME="$HOME/.jabba/jdk/$JDK"
    export PATH="$JAVA_HOME/bin:$PATH"
    # Apparently exported variables are ignored in subseguent phases on Windows. Write in config file
    echo "export JAVA_HOME=\"${JAVA_HOME}\"" >> ~/.windows_config
    echo "export PATH=\"${PATH}\"" >> ~/.windows_config
    # Windows is unable to clean child processes, so no Gradle daemon allowed
    echo 'export GRADLE_OPTS="-Dorg.gradle.daemon=false"' >> ~/.windows_config
}

echo "running ${TRAVIS_OS_NAME}-specific configuration"
$TRAVIS_OS_NAME
install_jdk
which java
java -Xmx32m -version
