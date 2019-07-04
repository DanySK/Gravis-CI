I am frankly tired of Travis CI's Java builds to fail continuously due to errors in downloading and installink the JDK.
As @sormuras [pointed out](https://travis-ci.community/t/install-jdk-sh-failing-for-openjdk9-and-10/3998/19), they are abusing the great install-jdk.sh tool.

The consequences are low reliability for Java builds, which defeat the point of having the continuous integration in place. Plus, currently Java is not supported under Windows.

Time to end this.
This project is meant to provide a number of script to be used in Java builds on Travis CI for running Java.
The project is focused on Gradle, as it's my favourite tool, but could be of use for Maven, Ant, and SBT users as well.

We rely on [Jabba](https://github.com/shyiko/jabba) to install the JDK, kudos to them!

## Usage

Base idea: download the scripts from GitHub and run them.
Here is the relevant part of your `.travis.yml`.
Code comments contain relevant details, please read them.

```yaml
# Java is not yet supported on Windows, so the build would block.
# You do not need any setup from Travis, use a plain bash build
language: bash
# Enable them all, if you need them.
os:
  - linux
  - osx
  - windows
env:
    # This is a convenience variable for shortening download commands
    - GRAVIS="https://raw.githubusercontent.com/DanySK/Gravis-CI/master/"
  matrix:
    # List any JDK you want to build your software with.
    # You can see the list of supported environments by installing Jabba and using ls-remote:
    # https://github.com/shyiko/jabba#usage
    - JDK="adopt@1.8.212-04"
    - JDK="amazon-corretto@1.8.212-04.2"
cache:
  directories:
    # Avoid re-downloading the JDK every time
    - $HOME/.jabba/
    # If you use Gradle, you may want to save some time with caching
    - $HOME/.gradle/caches/
    - $HOME/.gradle/wrapper/
before_install:
  # Sets up the Java environment
  - curl "${GRAVIS}.install-jdk-travis.sh" --output .install-jdk-travis.sh
# This is *required*, Travis CI does not seem to keep exported variables
before_script:
  - bash .install-jdk-travis.sh
#  - source ~/.jdk_config"
# This is your main script
script:
  # Just an example. Do what you deem useful
  - ./gradlew clean check --scan --parallel
# Cleanup the build cache from lock/temporary files
before_cache:
  - curl "${GRAVIS}.clean_gradle_cache.sh" --output .clean_gradle_cache.sh
  - bash .clean_gradle_cache.sh
```

## Contributing to the project

I gladly review pull requests and I'm happy to improve the work.
If the software was useful to you, please consider supporting my development activity
[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=5P4DSZE5DV4H2&currency_code=EUR)
