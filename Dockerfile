FROM alpine:latest

# Install necessary packages
RUN apk update && \
    apk add --no-cache \
    nfs-utils \
    rpcbind \
    curl \
    iproute2 \
    bash \
    openrc \
    samba

# Install Tailscale
RUN apk add --no-cache --repository https://pkgs.tailscale.com/stable/apk/ tailscale

# Create and set permissions for the NFS export and SMB share directories
RUN mkdir -p /exports /samba_share && \
    chown nobody:nogroup /exports /samba_share && \
    chmod 777 /exports /samba_share

# Configure NFS
RUN echo 'nfs_server_files="/exports"' > /etc/conf.d/nfs && \
    echo "/exports *(rw,sync,no_subtree_check,fsid=0,no_root_squash)" > /etc/exports

# Configure Samba
COPY smb.conf /etc/samba/smb.conf

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
