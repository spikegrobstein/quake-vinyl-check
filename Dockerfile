FROM alpine:3.10

RUN apk add --no-cache bash curl

COPY pup_v0.4.0_linux_amd64 /usr/local/bin/pup

COPY check.sh /q1-vinyl-check.bash

RUN chmod +x \
      /usr/local/bin/pup \
      /q1-vinyl-check.bash

CMD /q1-vinyl-check.bash
