FROM alpine:3.12.1

ENV BUNGEE_CORD_BUILD=1539

# install dependencies
RUN apk add --no-cache \
        openjdk8-jre \
        screen \
        tini \
        wget \
    && rm -rf /var/cache/apk/*

WORKDIR /var/velocity
COPY . /var/velocity
RUN mkdir plugins \
    && wget -O velocity.jar --quiet https://versions.velocitypowered.com/download/1.1.2.jar \
    && wget -O plugins/LuckPerms-Velocity-5.2.45.jar --quiet https://ci.lucko.me/job/LuckPerms/1210/artifact/velocity/build/libs/LuckPerms-Velocity-5.2.45.jar

ENTRYPOINT [ "tini", "--" ]
CMD [ "/bin/sh", "startup.sh" ]