FROM alpine:3.16

RUN apk update \
 && apk add --no-cache \
            bash \
            mysql-client

COPY application/ /data/
WORKDIR /data

CMD ["./entrypoint.sh"]
