#!/bin/bash

# GLOBALS
NORMAL="\033[0m"
YELLOW="\033[33m"
RED="\033[31m"
BLUE="\033[34m"


#Check for entrypoint config file
if [[ ! -e /entrypoint.cfg ]]; then
  echo $RED"ERROR:"$NORMAL"entrypoint config file is missing"
  echo "EXITING !!!"
  exit 1
fi

source /entrypoint.cfg

#Fix user accounts
chsh -s /bin/bash backup
usermod -aG backup root
usermod -g backup root
usermod -aG sudo backup

#fix ownership
chown -R backup:backup /etc/proxmox-backup
chown -R backup:backup /var/log/proxmox-backup
chown -R backup:backup /var/lib/proxmox-backup
chmod -R 700 /etc/proxmox-backup
chmod -R 700 /var/log/proxmox-backup
chmod -R 700 /var/lib/proxmox-backup

#Set root password
echo -e "root:${ROOT_PASSWD}" | chpasswd

echo
echo "Creating symlinks"
ln -s /usr/lib/x86_64-linux-gnu /usr/lib/aarch64-linux-gnu

#Starting API
echo
echo "API: Starting..."
/usr/lib/x86_64-linux-gnu/proxmox-backup/proxmox-backup-api &

#sleep 10s
secs="4"
secs_remains=$secs
while [ $secs_remains -gt 0 ]; do
   secs_remains=$(($secs_remains-1))
   sleep 1
   echo -e "Waiting for "$YELLOW"$secs_remains"$NORMAL"s"
done

echo
echo -e "Proxmox backup started at : https://$BLUE${CONTAINER_IP}$NORMAL:$BLUE${PBS_PORT}$NORMAL"
echo
echo -e "Default login = "$BLUE"root"$NORMAL
echo -e "Default password = "$BLUE"$ROOT_PASSWD"$NORMAL

if [[ ! -d "${NFS_DATASTORE_CONTAINER_PATH}/.chunks/" ]]; then
  echo "NFS Datastore not initialized"
  echo "Datastore initializing"
  echo "This may take several minutes, depending on your NFS backend performances"
  proxmox-backup-manager datastore create nfs-datastore $NFS_DATASTORE_CONTAINER_PATH
elif [[ ! -e /etc/proxmox-backup/datastore.cfg ]]; then
  echo "Using existing datastore at "${NFS_DATASTORE_CONTAINER_PATH}
  rm -f "${NFS_DATASTORE_CONTAINER_PATH}/.lock"
  echo 'datastore: nfs-datastore' > /etc/proxmox-backup/datastore.cfg
  echo "    path ${NFS_DATASTORE_CONTAINER_PATH}" >> /etc/proxmox-backup/datastore.cfg
fi

echo "PROXY: Starting..."
sudo -u backup /usr/lib/x86_64-linux-gnu/proxmox-backup/proxmox-backup-proxy

