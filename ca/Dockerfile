FROM alpine:3.15.4

ARG USER_UID
ARG USER_GID
ARG USER_NAME


ENV SRC_DIR /src


RUN apk --no-cache add openssl gettext shadow


COPY ca/src $SRC_DIR
WORKDIR $SRC_DIR


# グループの存在をGIDで確認し、適切にグループを作成または修正
RUN existing_group=$(getent group $USER_GID | cut -d: -f1); \
    if [ -z "$existing_group" ]; then \
        if ! getent group $USER_NAME > /dev/null 2>&1; then \
            addgroup -g $USER_GID $USER_NAME; \
        fi \
    else \
        if [ "$existing_group" != "$USER_NAME" ]; then \
            groupmod -n $USER_NAME $existing_group; \
        fi \
    fi

# ユーザーの存在を確認し、適切なグループ名でユーザーを作成
RUN if ! getent passwd $USER_NAME > /dev/null 2>&1; then \
      actual_group_name=$(getent group $USER_GID | cut -d: -f1); \
      adduser -D -u $USER_UID -G $actual_group_name $USER_NAME; \
    fi


RUN chown -R $USER_NAME:$USER_NAME $SRC_DIR
RUN chmod +x ./gen.sh


USER $USER_NAME


RUN mkdir -p demoCA/newcerts
RUN echo 00 > demoCA/serial
RUN touch demoCA/index.txt
RUN mkdir -p demoCA/newcerts


CMD ["./gen.sh"]

