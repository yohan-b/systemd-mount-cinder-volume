#!/bin/bash
#Absolute path to this script
SCRIPT=$(readlink -f $0)
#Absolute path this script is in
SCRIPTPATH=$(dirname $SCRIPT)

cat << EOF > "/etc/systemd/system/mnt-cinder-volume@.service"
[Unit]
Description=Mount cinder volume %I
Before=docker.service
After=network-online.target firewalld.service
Wants=network-online.target

[Service]
Type=oneshot
User=$SUDO_USER
ExecStart=$SCRIPTPATH/mount-cinder-volume.sh %i

[Install]
WantedBy=docker.service
EOF
systemctl daemon-reload
