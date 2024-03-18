FROM alpine:3.15.4

ARG USER_UID
ARG USER_GID
ARG USER_NAME


ENV CA_DIR /ca
ENV SRC_DIR /src


RUN apk --no-cache add openssl gettext


COPY ca/out $CA_DIR
COPY server/src $SRC_DIR
WORKDIR $SRC_DIR


RUN addgroup -g $USER_GID $USER_NAME \
  && adduser -D -u $USER_UID -G $USER_NAME $USER_NAME


RUN chown -R $USER_NAME:$USER_NAME $CA_DIR
RUN chown -R $USER_NAME:$USER_NAME $SRC_DIR
RUN chmod +x ./gen.sh


USER $USER_NAME


RUN mkdir -p demoCA/newcerts
RUN echo 00 > demoCA/serial
RUN touch demoCA/index.txt
RUN mkdir -p demoCA/newcerts


CMD ["./gen.sh"]

