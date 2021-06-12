FROM i386/alpine:edge

RUN apk update && apk add bash dpkg

COPY qbittorrent-nox-static.sh /root/qbittorrent-nox-static.sh
COPY deb.sh /root/deb.sh
