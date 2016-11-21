FROM alpine:3.4

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN addgroup -S disque && adduser -S -G disque disque

# grab su-exec for easy step-down from root
RUN apk add --no-cache 'su-exec>=0.2'

ENV DISQUE_VERSION 1.0-rc1
ENV DISQUE_DOWNLOAD_URL https://github.com/antirez/disque/archive/1.0-rc1.tar.gz

COPY config.h-glibc-backtrace.diff /usr/src/disque/

RUN set -x \
	&& apk add --no-cache --virtual .build-deps \
		gcc \
		linux-headers \
		make \
		musl-dev \
		openssl \
		tar \
	&& wget -O disque.tar.gz "$DISQUE_DOWNLOAD_URL" \
	&& mkdir -p /usr/src/disque \
	&& tar -xzf disque.tar.gz -C /usr/src/disque --strip-components=1 \
	&& rm disque.tar.gz \
	&& (cd /usr/src/disque && patch -p0 < config.h-glibc-backtrace.diff) \
	&& make -C /usr/src/disque \
	&& make -C /usr/src/disque install \
	&& rm -r /usr/src/disque \
	&& apk del .build-deps

RUN mkdir /data && chown disque:disque /data
VOLUME /data
WORKDIR /data

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 7711
CMD [ "disque-server" ]
