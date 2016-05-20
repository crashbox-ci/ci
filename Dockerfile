FROM debian:jessie-backports

MAINTAINER Jakob Odersky <jakob@odersky.com>

ENV SBT_VARIANTS 0.13.11
ENV SCALA_VARIANTS 2.10.6 2.11.8 2.12.0-M4

# install base utilities
RUN \
    apt-get update && \
    apt-get install -y \
        build-essential \
	autoconf \
	automake \
	libtool \
	cmake \
        wget \
        curl \
        git \
	openssl \
	openjdk-8-jdk \
	python \
	apt-transport-https \
	gnupg2 \
	nano

# install sbt
RUN \
    echo "deb https://dl.bintray.com/sbt/debian /" > /etc/apt/sources.list.d/sbt.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 && \
    apt-get update && \
    apt-get install -y sbt

# clean environment
RUN \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# setup and switch to ci user
RUN adduser --system --group ci
USER ci

# initialize sbt
RUN \
    mkdir /tmp/sbt && \
    cd /tmp/sbt && \
    mkdir -p project src/main/scala && \
    touch src/main/scala/scratch.scala && \
    for SBT_VERSION in $SBT_VARIANTS ; do \
    	echo "sbt.version=$SBT_VERSION" > project/build.properties && \
	for SCALA_VERSION in $SCALA_VARIANTS ; do \
    	    sbt ++$SCALA_VERSION clean updateClassifiers compile ; \
    	done ; \
    done && \
    rm -rf /tmp/sbt
