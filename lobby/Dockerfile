FROM alpine:3.12.1

# install dependencies
RUN apk add --no-cache \
        openjdk8-jre \
        tini \
        screen \
        wget

ENV MINECRAFT_DIR='/opt/minecraft' \
    EULA=true \
    WORLD_NAME=lobby

WORKDIR ${MINECRAFT_DIR}
ADD server/ ${MINECRAFT_DIR}/
ADD plugins/ ${MINECRAFT_DIR}/volume/plugins
ADD world/ ${MINECRAFT_DIR}/volume/worlds/world
#COPY world/server.properties ${MINECRAFT_DIR}/worlds/${WORLD_NAME}/server.properties
RUN wget --quiet -O paper.jar https://papermc.io/api/v1/paper/1.12.2/1618/download \
    # accept eula
    && echo eula=${EULA} > eula.txt \
    # unpack mods
    && unzip -d volume/plugins volume/plugins/plugins.zip \
    && rm volume/plugins/plugins.zip

RUN screen -dmS lobby sh start_server.sh \
    && echo "waiting for server to start..." \
    && sleep 20 \
    && sessionName=$(screen -ls | awk '/\.lobby\t/ {print $1;exit;}') \
    && echo "attempting to refresh ${sessionName} portals" \
    && screen -S $sessionName -X stuff iportal refresh rlcraft \
    && sleep 5

# backup and restart server once per day
#VOLUME ${MINECRAFT_DIR}/worlds
#VOLUME ${MINECRAFT_DIR}/plugin_data/backups
#VOLUME /etc/periodic

ENTRYPOINT ["tini", "--"]
CMD [ "/bin/sh", "start_server.sh" ]
