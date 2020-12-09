FROM alpine:3.12.1

# install dependencies
RUN apk add --no-cache \
        openjdk8-jre \
        tini \
        screen \
        wget

ENV MINECRAFT_DIR='/opt/minecraft' \
    EULA=true \
    WORLD_NAME=stoneblock2 \
    STONEBLOCK_VERSION=1.15.0 \
    FORGEJAR="FTBserver-1.12.2-14.23.5.2838-universal.jar" \
    JAVACMD="java" \
    MAX_RAM="2048M" \
    SERVER_PORT=30067
ENV JAVA_PARAMETERS="-Xmx${MAX_RAM} -XX:+UseParNewGC -XX:+CMSIncrementalPacing -XX:+CMSClassUnloadingEnabled -XX:ParallelGCThreads=5 -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10"

WORKDIR ${MINECRAFT_DIR}
ADD server/ ${MINECRAFT_DIR}/
ADD config/ ${MINECRAFT_DIR}/config/
RUN wget --quiet https://media.forgecdn.net/files/2727/712/FTBPresentsStoneblock2Server_${STONEBLOCK_VERSION}.zip \
    && unzip -n FTBPresentsStoneblock2Server_${STONEBLOCK_VERSION}.zip \
    && rm FTBPresentsStoneblock2Server_${STONEBLOCK_VERSION}.zip \
    && sh FTBInstall.sh \
    && cd mods/ \
    && wget --quiet https://repo.spongepowered.org/maven/org/spongepowered/spongeforge/1.12.2-2838-7.3.0/spongeforge-1.12.2-2838-7.3.0.jar \
    && wget --quiet https://ci.lucko.me/job/LuckPerms/1210/artifact/sponge/build/libs/LuckPerms-Sponge-5.2.45.jar \
    # force spongeforge to load its mixin first to avoid incompatibilities
    && mv spongeforge-1.12.2-2838-7.3.0.jar __aaaspongeforge-1.12.2-2838-7.3.0.jar \
    && cd .. \
    && echo "eula=${EULA}" > eula.txt \
    # workaround to parameterize awk regexp because i am noob
    && sed -i "s/<world-name>/${WORLD_NAME}/g" start_server.sh \
    && sed -i "s/<server-port>/${SERVER_PORT}/g" server.properties

ENTRYPOINT ["tini", "--"]
CMD ["sh", "start_server.sh"]