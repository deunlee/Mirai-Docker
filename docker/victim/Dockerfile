FROM alpine:3.15

RUN set -eux; \
	apk add --no-cache bash busybox-extras tcpdump htop;
	# shadow

COPY *.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
