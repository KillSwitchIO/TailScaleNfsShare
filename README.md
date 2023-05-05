# NFS-Tailscale Docker Container

This Docker container sets up an NFS server and exposes it via the Tailscale network. It allows you to share files and directories with other devices on your Tailscale network.


## Features
- NFS server running on Ubuntu 20.04
- Exposes NFS shares via Tailscale
- Easily configurable with environment variables


## Prerequisites
- Docker installed on the host system
- Tailscale installed on the host system
- Tailscale auth key


## How to Run the Docker Container
To run the NFS-Tailscale Docker container, use the following command:

`docker run -d --name nfs-tailscale --cap-add=NET_ADMIN --cap-add=SYS_MODULE --device /dev/net/tun --privileged -v /path/to/local/share:/exports -v /path/to/local/share:/samba_share -e HOSTNAME=smbtailscale -e TAILSCALE_AUTH_KEY=your_auth_key_here nfs-tailscale`


Replace `/path/to/local/share` with the local path to the directory you want to share via NFS, and `your_auth_key_here` with your actual Tailscale auth key.


## Accessing the NFS Share
To access the NFS share from another device on the Tailscale network, you will need to:

1. Install Tailscale on the other device and connect to the network.
2. Mount the NFS share using the Tailscale IP of the system running the Docker container. For example:

`sudo mount -t nfs -o vers=4.2 TAILSCALE_IP:/ /path/to/mount/point`


Replace `TAILSCALE_IP` with the Tailscale IP of the system running the Docker container and `/path/to/mount/point` with the local path where you want to mount the NFS share.


## Creating a Tailscale Auth Key
To create a Tailscale auth key that does not expire, follow these steps:
1. Log in to the [Tailscale admin console](https://login.tailscale.com/admin) using your Tailscale account.
2. Click on the "Authentication" tab.
3. Under the "Auth Keys" section, click the "Add key" button.
4. Enter a name for the key (e.g., "nfs-docker-key").
5. Set the "Key type" to "Machine".
6. Set the "Expiration" to "Never" to create a key that does not expire.
7. Click "Create key".
8. Copy the newly created key.

Now you have a Tailscale auth key that does not expire. Use this key when running the NFS-Tailscale Docker container by setting the TAILSCALE_AUTH_KEY environment variable.

```bash
docker run -d --name nfs-smb-tailscale-alpine --cap-add=NET_ADMIN --cap-add=SYS_MODULE --device /dev/net/tun --privileged -v /path/to/local/share:/exports -v /path/to/local/share:/samba_share -e TAILSCALE_AUTH_KEY=your_auth_key_here nfs-smb-tailscale-alpine
```

Replace your_auth_key_here with the Tailscale auth key you created.


## Building the Docker Image

To build the Docker image for the NFS and SMB (Samba) server, follow these steps:

1. In the same directory as the Dockerfile, create a new file called `smb.conf` and paste the contents provided in the previous section.

2. Ensure the `entrypoint.sh` script is also in the same directory and contains the updates from the previous section.

3. Open a terminal, navigate to the directory containing the Dockerfile, and run the following command:

```bash
docker build -t nfs-smb-tailscale-alpine .
```

This command will build the Docker image with NFS and SMB support and tag it with the name nfs-smb-tailscale-alpine.