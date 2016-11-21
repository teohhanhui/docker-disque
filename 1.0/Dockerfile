FROM debian:jessie

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r disque && useradd -r -g disque disque

RUN apt-get update && apt-get install -y --no-install-recommends \
		ca-certificates \
		wget \
	&& rm -rf /var/lib/apt/lists/*

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN set -x \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true

ENV DISQUE_VERSION 1.0-rc1
ENV DISQUE_DOWNLOAD_URL https://github.com/antirez/disque/archive/1.0-rc1.tar.gz

RUN buildDeps='gcc libc6-dev make' \
	&& set -x \
	&& apt-get update && apt-get install -y $buildDeps --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/* \
	&& wget -O disque.tar.gz "$DISQUE_DOWNLOAD_URL" \
	&& mkdir -p /usr/src/disque \
	&& tar -xzf disque.tar.gz -C /usr/src/disque --strip-components=1 \
	&& rm disque.tar.gz \
	&& make -C /usr/src/disque \
	&& make -C /usr/src/disque install \
	&& rm -r /usr/src/disque \
	&& apt-get purge -y --auto-remove $buildDeps

RUN mkdir /data && chown disque:disque /data
VOLUME /data
WORKDIR /data

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 7711
CMD [ "disque-server" ]
