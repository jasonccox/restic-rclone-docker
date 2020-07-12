FROM alpine

# install restic, rclone, and tzdata
ARG RESTIC_URL=https://github.com/restic/restic/releases/download/v0.9.6/restic_0.9.6_linux_amd64.bz2
ARG RCLONE_URL=https://downloads.rclone.org/rclone-current-linux-amd64.zip

RUN wget -O - $RESTIC_URL | bzip2 -d -c > /bin/restic && \
    wget -O rclone.zip $RCLONE_URL && \
    unzip rclone.zip && \
    mv rclone-*/rclone /bin/rclone && \
    chmod +x /bin/restic /bin/rclone && \
    rm -rf rclone.zip rclone-* && \
    apk add --no-cache tzdata

# copy needed scripts
COPY ./backup /bin/backup
COPY ./runner /bin/runner
COPY ./prune /bin/prune
COPY ./log.sh /usr/lib/log.sh

ENV CRON='0 0 * * *' \
    FORGET_ARGS='--keep-daily 7 --keep-weekly 5 --keep-monthly 12' \
    PRUNE_CRON='0 3 1 * *'

HEALTHCHECK --retries=1 CMD ps a | grep -v grep | grep crond || exit 1

# /data holds data to be backed up
VOLUME ["/data", "/root/.config/rclone"]

CMD ["runner"]

