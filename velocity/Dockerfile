FROM alpine:3.12.1

ENV BUNGEE_CORD_BUILD=1539

# install dependencies
RUN apk add --no-cache \
        openjdk8-jre \
        python3 \
        screen \
        tini \
        wget \
        iptables \
    && rm -rf /var/cache/apk/* \
    && if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi \
    && python3 -m ensurepip \
    && rm -r /usr/lib/python*/ensurepip \
    && pip3 install --no-cache --upgrade pip setuptools wheel \
    && if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi

WORKDIR /var/velocity
COPY . /var/velocity
RUN wget -O velocity.jar --quiet https://versions.velocitypowered.com/download/1.1.2.jar

ENTRYPOINT [ "tini", "--" ]
CMD [ "/bin/sh", "startup.sh" ]