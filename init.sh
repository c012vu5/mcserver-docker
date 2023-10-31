#!/bin/sh

function main () {
    dependencies curl wget

    if [ -e .env ]; then
        echo Initialize .env has already been completed.
    else
        cat > .env << EOF
# By default, CUR=./Volume/current, BAK=./Volume/backup
# Current world data location
CUR=
# Backup world data location
BAK=

# Server settings; see https://minecraft.fandom.com/ja/wiki/Server.properties
RAM_ALLOC=4G
DIFF=easy
VIEW_DISTANCE=10
MAX_HEIGHT=256

# Server management settings; BACKUP_TIME format %H:%M:%S
RCON_ENABLE=true
RCON_PSWD=minecraft
GRACE_TIME=60s
BACKUP_TIME=04:00:00
MAX_BACKUP=10

# Server version; see https://mcversions.net/
SERVER_VER=
EOF

        echo Initialize .env has been completed.
    fi
    echo -e "Edit it as you wish.\n"

    if [ -e server.jar ]; then
        echo Download server.jar has already been completed.
    else
        LATEST_SERVER=`curl -s "https://mcversions.net/" | grep -oP 'Latest Release.*?\K\d+\.\d+\.\d+'`
        echo Download latest server.jar : ${LATEST_SERVER}
        wget -q `curl -s "https://mcversions.net/download/${LATEST_SERVER}" | grep -o 'https://piston-data.mojang.com/v1/objects/[^"]*/server.jar'`
    fi
}

function dependencies () {
    local MISSING=()
    for CMD in $@; do
        if ! type ${CMD} &> /dev/null; then
            MISSING+=(${CMD})
        fi
    done
    if [ ${#MISSING[@]} -ne 0 ]; then
        echo -e "Dependencies error : \e[0;31m${MISSING[@]}\e[0;39m not found."
        exit 1
    fi
}

main
