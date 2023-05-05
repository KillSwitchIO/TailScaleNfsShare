#!/bin/bash
set -e

# Set the container hostname
hostname nfs-smb-tailscale-alpine

# Check if TAILSCALE_AUTH_KEY is provided
if [[ -z "${TAILSCALE_AUTH_KEY}" ]]; then
    echo "TAILSCALE_AUTH_KEY environment variable is required."
    exit 1
fi

# Start the NFS server
# Check if the NFS service is already running or starting
# NFS_STATUS=$(rc-service nfs status)
# if [[ $NFS_STATUS == *"stopped"* ]]; then
#   # Start the NFS server
#   rc-service nfs start
# else
#   echo "NFS service is already running or starting."
# fi

# # Start the Samba server
# rc-service samba start

# # Enable Samba server at boot
# rc-update add samba default

# Start the NFS server
# echo "Starting NFS server..."
# /usr/sbin/rpcbind
# /usr/sbin/rpc.nfsd
# /usr/sbin/exportfs -r

# Start the Samba server
echo "Starting Samba server..."
/usr/sbin/nmbd -D
/usr/sbin/smbd -D

# Authenticate and start

# Check if NFS mount is working
# echo "Checking NFS mount status..."
# sleep 3
# SHOWMOUNT_OUTPUT=$(showmount -e 127.0.0.1)
# if [[ $SHOWMOUNT_OUTPUT == *"/exports"* ]]; then
#     echo "NFS mount is working. Available exports:"
#     echo "$SHOWMOUNT_OUTPUT"
# else
#     echo "NFS mount is not working. Exiting."
#     exit 1
# fi

# Start tailscaled in the background
echo "Starting tailscaled..."
tailscaled > /dev/null 2>&1 &
sleep 5

# Authenticate and start Tailscale
tailscale up --authkey $TAILSCALE_AUTH_KEY

# Keep the container running
tail -f /dev/null
