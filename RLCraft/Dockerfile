FROM alpine:3.12.1

# install dependencies
RUN apk add --no-cache \
        openjdk8-jre \
        tini \
        screen \
        wget

ENV MINECRAFT_DIR=/opt/minecraft \
    EULA=true \
    WORLD_NAME=rlcraft \
    SERVER_PORT=30068

WORKDIR ${MINECRAFT_DIR}
# download forge, mods, mod-packs from forge cdn
RUN wget --quiet https://files.minecraftforge.net/maven/net/minecraftforge/forge/1.12.2-14.23.5.2838/forge-1.12.2-14.23.5.2838-installer.jar  \
    && java -jar forge-1.12.2-14.23.5.2838-installer.jar --installServer \
    && java -jar forge-1.12.2-14.23.5.2838-universal.jar \
    && echo "Installing server pack" \
    && wget --quiet https://media.forgecdn.net/files/2935/323/RLCraft+Server+Pack+1.12.2+-+Beta+v2.8.2.zip \
    && unzip RLCraft+Server+Pack+1.12.2+-+Beta+v2.8.2.zip \
    && cd mods/ \
    && wget --quiet https://media.forgecdn.net/files/2979/758/Chunk+Pregenerator+V1.12-2.3.jar \
    && wget --quiet https://repo.spongepowered.org/maven/org/spongepowered/spongeforge/1.12.2-2838-7.3.0/spongeforge-1.12.2-2838-7.3.0.jar \
    && wget --quiet https://ci.lucko.me/job/LuckPerms/1210/artifact/sponge/build/libs/LuckPerms-Sponge-5.2.45.jar \
    && cd .. \
    # accept eula
    && sed -i "s/eula=false/eula=${EULA}/g" eula.txt \
    # clean up
    && rm forge-*-installer.* \
    && rm RLCraft+Server+Pack+1.12.2+-+Beta+v2.8.2.zip

# configure rlcraft server
ADD server/ ${MINECRAFT_DIR}
ADD config/  ${MINECRAFT_DIR}/config/
RUN sed -i "s/<server-port>/${SERVER_PORT}/g" server.properties

ENTRYPOINT ["tini", "--"]
CMD [ "/bin/sh", "start_server.sh" ]
