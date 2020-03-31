#!/bin/bash
DIRECTORY=$HOME
test -z $1 && { echo "VOLUME variable is not defined."; exit 1; } || VOLUME="$1"
test -f $DIRECTORY/openrc.sh || { echo "ERROR: $DIRECTORY/openrc.sh not found, exiting."; exit 1; }
source $DIRECTORY/openrc.sh
INSTANCE=$($DIRECTORY/env_py3/bin/openstack server show -c id --format value $(hostname))
sudo mkdir -p /mnt/volumes/${VOLUME}
if ! mountpoint -q /mnt/volumes/${VOLUME}
then
     VOLUME_ID=$($DIRECTORY/env_py3/bin/openstack volume show ${VOLUME} -c id --format value)
     test -e /dev/disk/by-id/*${VOLUME_ID:0:20} || nova volume-attach $INSTANCE $VOLUME_ID auto
     sleep 3
     sudo mount /dev/disk/by-id/*${VOLUME_ID:0:20} /mnt/volumes/${VOLUME}
     mountpoint -q /mnt/volumes/${VOLUME} || { echo "ERROR: could not mount /mnt/volumes/${VOLUME}, exiting."; exit 1; }
fi
