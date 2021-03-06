FROM debian:jessie-backports

MAINTAINER Jakob Odersky <jakob@odersky.com>

ENV SBT_VERSIONS 0.13.11 0.13.12
ENV SCALA_VERSIONS 2.10.6 2.11.8 2.12.0-M5

# install base utilities & sbt
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
	nano && \
    echo "deb https://dl.bintray.com/sbt/debian /" > /etc/apt/sources.list.d/sbt.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 && \
    apt-get update && \
    apt-get install -y sbt && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# initialize sbt
RUN \
    mkdir /tmp/sbt && \
    cd /tmp/sbt && \
    mkdir -p project src/main/scala && \
    touch src/main/scala/scratch.scala && \
    for SBT_VERSION in $SBT_VERSIONS ; do \
    	echo "sbt.version=$SBT_VERSION" > project/build.properties && \
	for SCALA_VERSION in $SCALA_VERSIONS ; do \
    	    sbt ++$SCALA_VERSION clean update updateClassifiers compile ; \
    	done ; \
    done && \
    rm -rf /tmp/sbt
