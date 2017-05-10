FROM debian:jessie

MAINTAINER mickael.canevet@camptocamp.com

# Install github_pki
ENV GOPATH=/go
RUN apt-get update && apt-get install -y golang-go git \
  && go get github.com/camptocamp/github_pki \
  && apt-get autoremove -y golang-go git \
  && rm -rf /var/lib/apt/lists/*

# Install and configure openssh-server
RUN apt-get update \
  && apt-get install -y openssh-server \
  && rm -f /etc/ssh/ssh_host_*_key* \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir /var/run/sshd /etc/ssh/ssh_host_keys \
  && sed -i -e 's@/etc/ssh/ssh_host@/etc/ssh/ssh_host_keys/ssh_host@g' /etc/ssh/sshd_config \
  && sed -i -e 's@^Subsystem sftp .*@Subsystem sftp internal-sftp@' /etc/ssh/sshd_config \
  && echo "Match User sftp" >> /etc/ssh/sshd_config \
  && echo "    AllowTcpForwarding no" >> /etc/ssh/sshd_config \
  && echo "    X11Forwarding no" >> /etc/ssh/sshd_config \
  && echo "    ForceCommand internal-sftp" >> /etc/ssh/sshd_config

# Configure ssh user
RUN useradd -r -d /home/sftp sftp \
  && mkdir -p /home/sftp/.ssh \
  && chown -R sftp.sftp /home/sftp \
  && ln -s /var/lib/data /home/sftp/data

# Define VOLUMES
VOLUME ["/var/lib/data", "/etc/ssh/ssh_host_keys"]

# Configure entrypoint and command
COPY docker-entrypoint.sh /
COPY docker-entrypoint.d /docker-entrypoint.d
ENTRYPOINT ["/docker-entrypoint.sh", "/usr/sbin/sshd", "-D"]
