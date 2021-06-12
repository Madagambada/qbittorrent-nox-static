#!/bin/bash

#Get versions
echo -e '\n################\n# Get version #\n################\n'
cd qbt-build/completed
verq=$(./qbittorrent-nox -v | sed 's/.*v//')

#Create deb
echo -e '\n##############\n# Create deb #\n##############\n'
mkdir -p qbittorrent-nox_$verq-1_i386/DEBIAN
mkdir -p qbittorrent-nox_$verq-1_i386/usr/local/bin
mkdir -p qbittorrent-nox_$verq-1_i386/etc/systemd/system
cp qbittorrent-nox qbittorrent-nox_$verq-1_i386/usr/local/bin/

cat <<EOF >qbittorrent-nox_$verq-1_i386/etc/systemd/system/qbittorrent-nox.service
[Unit]
Description=qBittorrent-nox service
Wants=network-online.target
After=local-fs.target network-online.target nss-lookup.target

[Service]
Restart=on-failure
RestartSec=3
Type=exec
#User=
ExecStart=/usr/local/bin/qbittorrent-nox

[Install]
WantedBy=multi-user.target
EOF

size=$(du -sc qbittorrent-nox_$verq-1_i386/usr/ qbittorrent-nox_$verq-1_i386/etc | tail -1 | sed 's/total//' | sed 's/.$//')

cat <<EOF >qbittorrent-nox_$verq-1_i386/DEBIAN/control
Package: qbittorrent-nox
Version: $verq-1
Architecture: i386
Maintainer: Madagambada
Installed-Size: $size
Section: net
Priority: optional
Description: qBittorrent-$verq
EOF

dpkg-deb --build qbittorrent-nox_$verq-1_i386
