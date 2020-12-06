FROM alpine:3.12.1

# install dependencies
RUN apk add --no-cache \
        openjdk8-jre \
        tini \
        screen \
        wget

ENV MINECRAFT_DIR=/opt/minecraft \
    EULA=true \
    WORLD_NAME=world

WORKDIR ${MINECRAFT_DIR}
RUN wget --quiet https://launcher.mojang.com/v1/objects/886945bfb2b978778c3a0288fd7fab09d315b25f/server.jar \
    && echo eula=$EULA > eula.txt

COPY start_server.sh ${MINECRAFT_DIR}/start_server.sh
COPY log4j2.xml ${MINECRAFT_DIR}/log4j2.xml

# forward logs to docker log collector
#RUN mkdir logs \
#    && touch ${MINECRAFT_DIR}/logs/latest.log \
#    && ln -sf /proc/$$/fd/1 ${MINECRAFT_DIR}/logs/latest.log

#ENTRYPOINT ["tini", "--"]
CMD [  "/bin/sh", "start_server.sh" ]
