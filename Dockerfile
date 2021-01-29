# FROM debian:buster
FROM debian:stable-20210111

#Install dependencies
RUN apt-get update
RUN apt-get install -y wget sudo ca-certificates

#Add repository
RUN echo "deb http://download.proxmox.com/debian/pbs buster pbs-no-subscription" > /etc/apt/sources.list.d/pbs-no-subscription.list
RUN wget http://download.proxmox.com/debian/proxmox-ve-release-6.x.gpg -O /etc/apt/trusted.gpg.d/proxmox-ve-release-6.x.gpg

#Install packages
RUN apt-get update
RUN apt-get install -y proxmox-backup-server=1.0.6-1

#start!

COPY entrypoint.sh /
COPY entrypoint.cfg /
RUN chmod a+x /entrypoint.sh
RUN chmod a+x /entrypoint.cfg
STOPSIGNAL SIGINT
ENTRYPOINT ["/entrypoint.sh"]
