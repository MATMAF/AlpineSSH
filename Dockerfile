FROM alpine:latest

RUN apk update

# Install OpenSSH server and create necessary directories
RUN apk add --no-cache openssh-server && \
    mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd

# Generate SSH host keys
RUN ssh-keygen -A

# Permit root login and disable PAM
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# Create SSH directory for root user
RUN mkdir -p /root/.ssh

# Clean up package cache and temporary files
RUN rm -rf /var/cache/apk/*

# Expose SSH port
EXPOSE 22

# Start SSH server
CMD ["/usr/sbin/sshd", "-D"]