I am frankly tired of Travis CI's Java builds to fail continuously due to errors in downloading and installing the JDK.
As @sormuras [pointed out](https://travis-ci.community/t/install-jdk-sh-failing-for-openjdk9-and-10/3998/19), they are abusing the great install-jdk.sh tool.

The consequences are low reliability for Java builds, which defeat the point of having the continuous integration in place. Plus, currently Java is not supported under Windows.

Time to end this.
This project is meant to provide a number of script to be used on Travis CI for simpolifying machine configuration from a minimal or bare image.
The project is focused on Java and Gradle, as it's the tool I use most often,
but with time is expanding to help installing other software.

## Usage

### Installing the JDK

We rely on [Jabba](https://github.com/shyiko/jabba) to install the JDK, kudos to them!

Base idea: download the scripts from GitHub and run them.
Here is the relevant part of your `.travis.yml`.
Code comments contain relevant details, please read them.

```yaml
# Java is not yet supported on Windows, so the build would block.
# You do not need any setup from Travis, use a plain bash build
language: minimal
# Enable them all, if you need them.
os:
  - linux
  - osx
  - windows
env:
  global:
    # Convenience variables for shortening commands
    - GRAVIS_REPO="https://github.com/DanySK/Gravis-CI.git"
    - GRAVIS="$HOME/gravis"
  matrix:
    # List any JDK you want to build your software with.
    # You can see the list of supported environments by installing Jabba and using ls-remote:
    # https://github.com/shyiko/jabba#usage
    - JDK="adopt@1.8.212-04"
    # Partial versions are allowed. They are dynamically resoved by launching jabba ls-remote,
    # filtering for the provided JDK string, then picking the *first* match. This is useful if
    # the intent is to target the latest release of some Java major release, or if the latest
    # available build differs among platforms.
    - JDK="adopt-openj9@1.11"
before_install:
  # Check out the script set
  - travis_retry git clone --depth 1 $GRAVIS_REPO $GRAVIS
  # Install the JDK you configured in the $JDK environment variable
  - source $GRAVIS/install-jdk
```
### Clean Gradle caching

Caching may help speeding up your Gradle build.
However, by default, the Gradle cache folder is always modified after a run.
The result is that Travis re-compresses and re-uploads the cache every time,
for no reason, spoiling the speedup.
We provide a script for cleaning up the cache,
making the build faster (and the cache smaller).

Here is the relevant part of your `.travis.yml`.
Code comments contain relevant details, please read them.

``` yaml
env:
  global:
    # Convenience variables for shortening commands
    - GRAVIS_REPO="https://github.com/DanySK/Gravis-CI.git"
    - GRAVIS="$HOME/gravis"
before_install:
  # Check out the script set
  - travis_retry git clone --depth 1 $GRAVIS_REPO $GRAVIS
before_cache:
  - $GRAVIS/clean-gradle-cache
cache:
  directories:
    - $HOME/.gradle/caches/
    - $HOME/.gradle/wrapper/
```

## Contributing to the project

I gladly review pull requests and I'm happy to improve the work.
If the software was useful to you, please consider supporting my development activity
[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=5P4DSZE5DV4H2&currency_code=EUR)
