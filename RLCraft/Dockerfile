FROM alpine:3.12.1

# install dependencies
RUN apk add --no-cache \
        openjdk8-jre \
        python3 \
        screen \
        tini \
        wget \
    && rm -rf /var/cache/apk/* \
    && if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi \
    && python3 -m ensurepip \
    && rm -r /usr/lib/python*/ensurepip \
    && pip3 install --no-cache --upgrade pip setuptools wheel \
    && if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi

ENV MINECRAFT_DIR='/opt/minecraft'

# install emsm
# do not add minecraft user/group as we run as root
ADD conf /opt/minecraft/conf
COPY minecraft.py /opt/minecraft/minecraft.py
RUN pip install --pre emsm \
    #&& addgroup -S minecraft \
    #&& adduser -S -H -G minecraft minecraft \
    && chmod +x /opt/minecraft/minecraft.py \
    && ln -s /opt/minecraft/minecraft.py /usr/local/bin/minecraft \
    #&& chown -R minecraft:minecraft /opt/minecraft \
    && minecraft emsm --version

ENV EULA=true
ENV WORLD_NAME=rlcraft
ENV SERVER_NAME=minecraft\ forge\ 1.12

WORKDIR ${MINECRAFT_DIR}

# download forge, mods, mod-packs from forge cdn
#RUN mkdir server && cd server \
#    && wget --quiet https://files.minecraftforge.net/maven/net/minecraftforge/forge/1.12.2-14.23.5.2854/forge-1.12.2-14.23.5.2854-installer.jar \
#    && java -jar forge-1.12.2-14.23.5.2854-installer.jar --installServer \
#    && rm forge-*-installer.*

# configure rlcraft server
COPY ${WORLD_NAME}/server.properties ${MINECRAFT_DIR}/worlds/${WORLD_NAME}
RUN minecraft -s "${SERVER_NAME}" server --update \
    # initialize world
    && minecraft -w "${WORLD_NAME}" worlds --start \
    && cd worlds/${WORLD_NAME} \
    # drop in mads
    && wget --quiet https://media.forgecdn.net/files/2935/323/RLCraft+Server+Pack+1.12.2+-+Beta+v2.8.2.zip \
    && wget --quiet https://media.forgecdn.net/files/2979/758/Chunk+Pregenerator+V1.12-2.3.jar \
    && wget --quiet https://repo.spongepowered.org/maven/org/spongepowered/spongeforge/1.12.2-2838-7.3.0/spongeforge-1.12.2-2838-7.3.0.jar \
    && unzip RLCraft+Server+Pack+1.12.2+-+Beta+v2.8.2.zip \
    && mv Chunk+Pregenerator+V1.12-2.3.jar mods/ \
    && mv spongeforge-1.12.2-2838-7.3.0.jar mods/ \
    # accept eula
    && sed -i "s/eula=false/eula=${EULA}/g" eula.txt \
    # clean up
    && rm RLCraft+Server+Pack+1.12.2+-+Beta+v2.8.2.zip

# fix Waystones; there is a bug where if you use a waystone
# you may lose your spawnpoint
COPY sponge/global.conf ${MINECRAFT_DIR}/worlds/${WORLD_NAME}/config
RUN cd worlds/${WORLD_NAME}/config \
    && sed -i 's/"Set Spawnpoint on Activation"=true/"Set Spawnpoint on Activation"=false/g' Waystones.cfg

# backup and restart server once per day
COPY server_maintenance.sh /etc/periodic/daily
COPY start_server.sh ${MINECRAFT_DIR}

VOLUME ${MINECRAFT_DIR}/worlds
VOLUME ${MINECRAFT_DIR}/plugin_data/backups
VOLUME /etc/periodic

EXPOSE 25565

ENTRYPOINT ["tini", "--"]
CMD [ "/bin/sh", "start_server.sh" ]
