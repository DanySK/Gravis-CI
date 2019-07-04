I am frankly tired of Travis CI's Java builds to fail continuously due to errors in downloading and installink the JDK.
As @sormuras [pointed out](https://travis-ci.community/t/install-jdk-sh-failing-for-openjdk9-and-10/3998/19), they are abusing the great install-jdk.sh tool.

The consequences are low reliability for Java builds, which defeat the point of having the continuous integration in place. Plus, currently Java is not supported under Windows.

Time to end this.
This project is meant to provide a number of script to be used in Java builds on Travis CI for running Java.
The project is focused on Gradle, as it's my favourite tool, but could be of use for Maven, Ant, and SBT users as well.

We rely on [Jabba](https://github.com/shyiko/jabba) to install the JDK, kudos to them!

