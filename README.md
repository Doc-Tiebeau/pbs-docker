# pbs-docker

Container that runs [Proxmox Backup Server](https://pbs.proxmox.com/) in a docker image with integrated NFS datastore mount (and initialization).

## Usage

1. Clone the repo
```
git clone 
```
2. Fill the .env file with the expected values

IMAGE_BALE is 


Example:
```
IMAGE_LABEL='0.0.1-rc1'
NFS_SERVER='192.168.1.1'
NFS_SHARE='/testpbs'
```
3. build the docker image
```
sudo docker build --force-rm --tag pbs-docker:<image_version>
```


