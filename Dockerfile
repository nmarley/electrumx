FROM ubuntu:16.10
MAINTAINER BlackCarrot <dev@blackcarrot.be>
LABEL description="Dockerised ElectrumX"

RUN /bin/echo 'set -o vi' >> /etc/profile
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install python3.6 python3.6-dev python3-pip librocksdb-dev libsnappy-dev libbz2-dev zlib1g-dev
RUN python3.6 -mpip install -U pip
RUN python3.6 -mpip install -U asyncio pylru aiohttp pyconfig pyrocksdb
RUN rm -fr /var/cache/apt/*

RUN echo '* soft nofile 40000' >> /etc/security/limits.conf
RUN echo '* hard nofile 99999' >> /etc/security/limits.conf

# Can be customised, any/all of these could be added/passed at runtime:
#
# https://github.com/kyuupichan/electrumx/blob/master/docs/ENVIRONMENT.rst
#
ENV COIN Dash
ENV DB_DIRECTORY /data
ENV NET mainnet
ENV DB_ENGINE rocksdb
ENV TCP_PORT 4567

VOLUME /data

WORKDIR /code
COPY . /code

# electrumx has a nanny check, remove it
RUN /usr/bin/patch -p1 < docker1.patch

CMD ["/usr/bin/python3.6", "/code/electrumx_server.py"]
