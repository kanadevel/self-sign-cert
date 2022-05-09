FROM alpine:3.15.4
RUN apk --no-cache add openssl gettext

COPY ca/src /src
WORKDIR /src

RUN chmod +x ./gen.sh

RUN mkdir -p demoCA/newcerts
RUN echo 00 > demoCA/serial
RUN touch demoCA/index.txt
RUN mkdir -p demoCA/newcerts

CMD ["./gen.sh"]
