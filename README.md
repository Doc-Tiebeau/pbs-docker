# pbs-docker
- [pbs-docker](#pbs-docker)
  - [Configuration](#configuration)
    - [The .env file](#the-env-file)
    - [The entrypoint.cfg file](#the-entrypointcfg-file)
  - [Usage](#usage)
    - [From Docker Hub builded image:](#from-docker-hub-builded-image)

Container that runs [Proxmox Backup Server](https://pbs.proxmox.com/) in a docker image with integrated NFS datastore mount (and initialization).

## Configuration

### The .env file

The .env file is used by `docker-compose` to set some values at needed to start your image.

`IMAGE_LABEL`: Specify the image label to pull from docker-hub  
`NFS_SERVER`: NFS server FQDN or IP  
`NFS_SHARE`: Is the path to the share exported by the server (find it with `showmount -e <FQDN|IP>`)  

### The entrypoint.cfg file

The entrypoint.cfg file has to be modified only if you build the image before run it.

`ROOT_PASSWD`: The root password configured at startup by the entrypoint.sh.  
`CONTAINER_IP` The container IP used by entrypoint tty output.  
`PBS_PORT` The Proxmox Backup Server https GUI port.  
`NFS_DATASTORE_CONTAINER_PATH` The path inside the container which the NFS datastore is mounted.

Example:
```
ROOT_PASSWD="pbs"
CONTAINER_IP="127.0.0.1"
PBS_PORT="8007"
NFS_DATASTORE_CONTAINER_PATH="/mnt/nfs-datastore"

```
NB: If needed, you can override this file by mounting another on it at `\entrypoint.cfg`.

## Usage

### From [Docker Hub builded image](https://hub.docker.com/r/doctiebeau/pbs-docker):

I recommend to use docker compose instead of docker which is more confortable to use
```
docker run doctiebeau/pbs-docker:<tag>
```

NB: Replace `<tag>` at the end of the docker pull command by the expected image tag name according to the published [Docker Hub image builds](https://hub.docker.com/r/doctiebeau/pbs-docker/tags)
doctiebeau/pbs-docker:<tag>
```
git clone https://github.com/Doc-Tiebeau/pbs-docker.git
```

2. Go to the root of the just cloned repo
3. Configure the images according to [Configuration](#configuration) section

4. build the docker image
```
sudo docker build --tag pbs-docker:<image_version>
```
Run it using docker-compose

```
docker-compose up -d
```