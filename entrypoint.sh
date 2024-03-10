#!/bin/sh

VOLUME=${VOLUME:-/volume}
ALLOW=${ALLOW:-127.0.0.1 192.168.0.0/16 172.16.0.0/12}
UID=${UID:-1000}
GID=${GID:-1000}

mkdir -p ${VOLUME}

getent group ${GID} > /dev/null || addgroup --gid ${GID} rsync-group
getent passwd ${UID} > /dev/null || adduser --system --uid ${UID} --gid ${GID} rsync-user

GROUP=`getent group ${GID} | cut -d: -f1`
USER=`getent passwd ${UID} | cut -d: -f1`

chown -R ${USER}:${GROUP} ${VOLUME}

cat <<EOF > /etc/rsyncd.conf
uid = ${USER}
gid = ${GROUP}
use chroot = yes
log file = /dev/stdout
reverse lookup = no
[volume]
    hosts deny = *
    hosts allow = ${ALLOW}
    read only = false
    path = ${VOLUME}
    comment = docker volume
EOF

exec /usr/bin/rsync --no-detach --daemon --config /etc/rsyncd.conf
