#!/bin/sh

main () {
    trap graceful_term TERM
    if [ ! -e eula.txt ] || [ "$(awk -F = /eula=/'{print $2}' eula.txt)" = "false" ]; then
        launch
        init
    fi

    launch&
    backup
}

graceful_term () {
    mcrcon -p "${RCON_PSWD}" "/stop"
    while [ "$(pgrep -c java)" = '1' ]
    do
        sleep 1s
    done
}

launch () {
    ln -sf /var/server.jar /mnt/current/server.jar
    java -Xmx"${RAM_ALLOC}" -Xms"${RAM_ALLOC}" -jar /mnt/current/server.jar nogui
}

init () {
    sed -i eula.txt \
        -e s/false/true/

    sed -i server.properties \
        -e /difficulty/s/easy/"${DIFF}"/ \
        -e /view-distance/s/10/"${VIEW_DISTANCE}"/ \
        -e /height/s/256/"${MAX_HEIGHT}"/ \
        -e /enable-rcon/s/false/"${RCON_ENABLE}"/ \
        -e /rcon.password/s/\$/"${RCON_PSWD}"/
}

backup () {
    while :
    do
        . ./.env
        NOW_EPOCH=$(date "+%s")
        TGT_EPOCH=$(date -d "${BACKUP_TIME}" "+%s")
        WAIT_SEC=$(( TGT_EPOCH - NOW_EPOCH ))
        if [ ${WAIT_SEC} -gt 0 ]; then
            sleep ${WAIT_SEC}s
        elif [ ${WAIT_SEC} -lt 0 ]; then
            sleep $(( WAIT_SEC + 86400 ))s
        fi

        mcrcon -p "${RCON_PSWD}" "/say §a§l§n自動アナウンス"
        mcrcon -p "${RCON_PSWD}" "/say §b${GRACE_TIME}§秒後に§lバックアップ§6及び§l再起動§6を行います。"
        sleep "${GRACE_TIME}"
        mcrcon -p "${RCON_PSWD}" "/say §cまもなくサーバーが自動停止します。"

        sleep 10s
        graceful_term

        tar -C /mnt/current/ -zcf /mnt/backup/"$(date "+%Y-%m-%d")"_world.tgz world
        while [ "$(find /mnt/backup -type f | wc -l)" -gt "${MAX_BACKUP}" ]
        do
            rm "$(find /mnt/backup -type f | sort | head -1)"
        done

        launch&
    done
}

main "$@"
