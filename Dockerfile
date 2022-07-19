FROM alpine:3.13

RUN apk add --no-cache grep git bash

COPY version.sh /

ENTRYPOINT ["/version.sh"]
