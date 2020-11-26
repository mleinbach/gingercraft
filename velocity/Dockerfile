FROM alpine:3.12.1

# install dependencies
RUN apk add --update --no-cache \
        openjdk8-jre \
        screen \
        tini \
        wget \
        iptables \
        awall \
    && rm -rf /var/cache/apk/*
    
RUN apk add --update --no-cache openrc \
    # Disable getty's
    && sed -i 's/^\(tty\d\:\:\)/#\1/g' /etc/inittab \
    && sed -i \
        # Change subsystem type to "docker"
        -e 's/#rc_sys=".*"/rc_sys="docker"/g' \
        # Allow all variables through
        -e 's/#rc_env_allow=".*"/rc_env_allow="\*"/g' \
        # Start crashed services
        -e 's/#rc_crashed_stop=.*/rc_crashed_stop=NO/g' \
        -e 's/#rc_crashed_start=.*/rc_crashed_start=YES/g' \
        # Define extra dependencies for services
        -e 's/#rc_provide=".*"/rc_provide="loopback net"/g' \
        /etc/rc.conf \
    # Remove unnecessary services
    && rm -f /etc/init.d/hwdrivers \
            /etc/init.d/hwclock \
            /etc/init.d/hwdrivers \
            /etc/init.d/modules \
            /etc/init.d/modules-load \
            /etc/init.d/modloop \
    # Can't do cgroups
    && sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh \
    && sed -i 's/VSERVER/DOCKER/Ig' /lib/rc/sh/init.sh

WORKDIR /var/velocity
COPY velocity.toml /var/velocity
COPY startup.sh /var/velocity
COPY awall/ /usr/share/awall
RUN wget -O velocity.jar --quiet https://versions.velocitypowered.com/download/1.1.2.jar

#ENTRYPOINT [ "tini", "--" ]
#CMD [ "/bin/sh", "startup.sh" ]

WORKDIR /etc/init.d
CMD ["/sbin/init"]