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
# plugins.tar.gz contains the actual .jar files whereas plugins directory contains config files
# they have been left out of the archive because ill likely be editing them frequently
ADD plugins.tar.gz ${MINECRAFT_DIR}/plugins
COPY plugins/ ${MINECRAFT_DIR}/plugins
ADD world.tar.gz ${MINECRAFT_DIR}/world
#COPY world/server.properties ${MINECRAFT_DIR}/worlds/${WORLD_NAME}/server.properties
RUN wget --quiet -O paper.jar https://papermc.io/api/v1/paper/1.12.2/1618/download \
    # accept eula
    && echo eula=${EULA} > eula.txt

#RUN screen -dmS lobby sh start_server.sh \
#    && echo "waiting for server to start..." \
#    && sleep 20 \
#    && sessionName=$(screen -ls | awk '/\.lobby\t/ {print $1;exit;}') \
#    && echo "attempting to refresh ${sessionName} portals" \
#    && screen -S $sessionName -X stuff iportal refresh rlcraft \
#    && sleep 5

VOLUME ${MINECRAFT_DIR}/world

ENTRYPOINT ["tini", "--"]
CMD [ "/bin/sh", "start_server.sh" ]
