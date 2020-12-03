# Important note

~~## The project has been discontinued

~~Due to the recent change of pricing policy of Travis CI, I had to migrate the entirety of my pipelines to GitHub Actions.
I also ran out of credits before even noticing they changed such policy, so it is now impossible to test whether Gravis CI is working or not.
As a consequence, I do not intend to keep on maintaining this project.
It is still working at the time of writing, and until Jabba will work, Gravis should work as well.
It is very sad to discontinue this project for me, but there's nothing I can do.
Unfortunately Travis CI is no longer FOSS-friendly.

~~I'm still using the `autotag` script on some of my GHA builds, so that one can be considered actively maintained.

## The project is back to maintenance

Apparently Travis CI reinstated their FOSS plan.
So the project can continue being maintained.

# Gravis-CI

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
  # Never use travis_retry: hides failures. travis_retry is used internally where possible.
  - source $GRAVIS/install-jdk
```

#### Caching the JDK

Jabba and the JDK can be cached by:

```yaml
cache:
  directories:
    # This avoids re-downloading the JDK every time, but Travis recommends not to do it
    - $HOME/.jabba/
```

However, please not that [*Travis-CI explicitly recommends not to do it*](https://docs.travis-ci.com/user/caching/#things-not-to-cache)

> The cache’s purpose is to make installing language-specific dependencies easy and fast, so everything related to tools like Bundler, pip, Composer, npm, Gradle, Maven, is what should go into the cache. Large files that are quick to install but slow to download do not benefit from caching, as they take as long to download from the cache as from the original source: [...] JDK packages


### Better Gradle caching

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

### Installing Apache Maven

Apache Maven does not ship an utility script similar to Gradle's wrapper.
As such, we provide a way to fetch and install it on the fly.
You may want to cherry pick what you need from the following snippet and use it in a build that also leverages Gravis for installing the JDK.

```yaml
env:
  global:
    - GRAVIS_REPO="https://github.com/DanySK/Gravis-CI.git"
    - GRAVIS="$HOME/gravis"
  # The following is optional
  matrix:
    # List any Maven you want to build your software with.
    # If omitted, the latest available version will be used.
    - MAVEN_VERSION="3.6.3"
    - MAVEN_VERSION="3.6.0"
before_install:
  # Check out the script set
  - travis_retry git clone --depth 1 $GRAVIS_REPO $GRAVIS
  # Never use travis_retry: hides failures. travis_retry is used internally where possible.
  # Java is required, either use "language: java" or, better, rely on Gravis
  - source $GRAVIS/install-jdk
  # Install the MAVEN_VERSION of your like
  - source $GRAVIS/install-maven
```

### Installing Python

Python is not provided in every travis environment.
The goal of the following is enabling multi-os installation via either [pyenv](https://github.com/pyenv/pyenv) or [pyenv-win](https://github.com/pyenv-win/pyenv-win).

```yaml
env:
  global:
    - GRAVIS_REPO="https://github.com/DanySK/Gravis-CI.git"
    - GRAVIS="$HOME/gravis"
  matrix:
    # List any Python version you want to run with
    - PYTHON="2.7.0"
    - PYTHON="3.6.0"
    # Partial matches allowed: pick the last matching
    - PYTHON="3"
    # Latest stable
    - PYTHON=""
before_install:
  # Check out the script set
  - travis_retry git clone --depth 1 $GRAVIS_REPO $GRAVIS
  # Never use travis_retry: hides failures. travis_retry is used internally where possible.
  - source $GRAVIS/install-python
cache:
  # Installing Python is quite slow. Caching is warmly recommended
  - $HOME/.pyenv
```

### Meaningful tagging for non-tag releases

It's possible to configure travis for releasing non-tagged branches.
However, it creates ugly `untagged-COMMITHASH` releases, and GitHub (reasonably) does not sort them by date.
Gravis proposes an alternative tagging system via appropriate script.
Strategy:
1. if there is a tag, that's the tag. (you don't say)
2. if git describe provides a meaningful output, then that's the tag: `lastTag-COMMIT_COUNT-COMMIT_HASH`, e.g., `1.2.3-32-foo42bar`
3. if no tag can be reached down the history, default to `0.1.0-COMMIT_DATE`, e.g. `0.1.0-2020-02-05T225533`

If tags are [Semantic Versioning](https://semver.org/) compatible, the output should remain Semantic Versioning compatible.

```yaml
# I strongly suggest to disable shallow clone, or tags may get lost
git:
  depth: false
env:
  global:
    - GRAVIS_REPO="https://github.com/DanySK/Gravis-CI.git"
    - GRAVIS="$HOME/gravis"
before_install:
  - travis_retry git clone --depth 1 $GRAVIS_REPO $GRAVIS
before_deploy:
  # The script requires appropriate git configuration.
  # This README's got my name so it's quicker for me to copy/paste. You want to change it.
  - git config --local user.name "Danilo Pianini"
  - git config --local user.email "danilo.pianini@gmail.com"
  - $GRAVIS/autotag
```

## Contributing to the project

I gladly review pull requests and I'm happy to improve the work.
If the software was useful to you, please consider supporting my development activity
[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=5P4DSZE5DV4H2&currency_code=EUR)
