FROM alpine:3.13

RUN apk add --no-cache git

# Use the GitHub Actions uid:gid combination for proper fs permissions
RUN addgroup -g 116 -S github && adduser -u 1001 -S -g github github

# Run as github user
USER github

COPY version.sh /

ENTRYPOINT ["/version.sh"]
