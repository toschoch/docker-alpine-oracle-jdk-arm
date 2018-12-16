Docker Alpine Oracle JDK for ARM
===============================
author: Tobias Schoch

Overview
--------

A alpine image for arm with oracle jvm v8


Change-Log
----------
##### 0.0.1
* initial version


Installation / Usage
--------------------
clone the repo:

```
git clone git@github.com:toschoch/docker-alpine-oracle-jdk-arm.git
```
build the docker image
```
docker build . -t alpine-oracle-jdk-arm
```

Example
-------

run a container of the image
```
docker run -v ... -p ... alpine-oracle-jdk-arm
```