# Dockerfile for k8s-toolkit on UBI 9 (compatible with Kubernetes & OpenShift)
FROM almalinux:latest

LABEL maintainer="lorenzo.biosa@yahoo.it" \
      version="1.0" \
      description="All-in-one troubleshooting toolkit for Kubernetes & OpenShift"

USER root
WORKDIR /root

# Add repos and Install software
RUN curl https://packages.microsoft.com/config/rhel/9/prod.repo | tee /etc/yum.repos.d/mssql-release.repo && \
    echo -e "[mongodb-org-8.0]\nname=MongoDB Repository\nbaseurl=https://repo.mongodb.org/yum/redhat/9/mongodb-org/8.0/x86_64/\ngpgcheck=1\nenabled=1\ngpgkey=https://pgp.mongodb.com/server-8.0.asc" > /etc/yum.repos.d/mongodb-org-8.0.repo && \
    dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm && \
    dnf install -y epel-release && dnf -qy module disable postgresql && dnf update -y && \
    dnf config-manager --disable pgdg13 pgdg14 pgdg15 pgdg16 && dnf config-manager --set-disabled pgdg13 pgdg14 pgdg15 pgdg16 && \
    dnf install -y https://download.oracle.com/otn_software/linux/instantclient/2380000/oracle-instantclient-basic-23.8.0.25.04-1.el9.x86_64.rpm && \
    dnf install -y https://download.oracle.com/otn_software/linux/instantclient/2380000/oracle-instantclient-sqlplus-23.8.0.25.04-1.el9.x86_64.rpm && \
    ACCEPT_EULA=Y dnf install -y adcli bash-completion bind-utils dhcping ethtool \
        fio file ftp fping gzip htop iftop ioping iotop iperf iperf3 iproute iptraf-ng iputils jq krb5-workstation \
        libnsl man mariadb mc mlocate mongodb-mongosh mssql-tools18 mtr ncdu net-snmp-utils net-tools nmap nmap-ncat \
        oddjob oddjob-mkhomedir openssh-clients openldap-clients \
        postgresql17 procps samba samba-common samba-winbind samba-winbind-clients sssd sssd-tools strace sysstat \
        tar tcpdump telnet tmux traceroute unixODBC-devel vim wireshark-cli wget which && \
    dnf clean all
    
# Install ttyd
RUN curl -fsSL -o /usr/local/bin/ttyd \
    https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 && \
    chmod +x /usr/local/bin/ttyd

# Install kubectl
RUN curl -fsSL -o /usr/local/bin/kubectl \
    https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl

# Install OpenShift CLI
RUN curl -fsSL -o /tmp/oc.tar.gz \
    https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-client-linux.tar.gz && \
    tar -xzf /tmp/oc.tar.gz -C /usr/local/bin oc && \
    chmod +x /usr/local/bin/oc && \
    rm /tmp/oc.tar.gz

# Install kubectl-neat
RUN curl -fsSL -o /tmp/kubectl-neat.tar.gz \
    https://github.com/itaysk/kubectl-neat/releases/download/v2.0.4/kubectl-neat_linux_amd64.tar.gz && \
    tar -xzf /tmp/kubectl-neat.tar.gz -C /usr/local/bin kubectl-neat && \
    chmod +x /usr/local/bin/kubectl-neat && \
    rm /tmp/kubectl-neat.tar.gz

# Install yq
RUN curl -fsSL -o /usr/local/bin/yq \
    https://github.com/mikefarah/yq/releases/download/v4.45.4/yq_linux_amd64 && \
    chmod +x /usr/local/bin/yq

RUN mkdir /www && updatedb && \
    echo "alias ll='ls -al --color=auto'" >> ~/.bashrc && \
    echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc && \
    oc completion bash > /etc/profile.d/oc.sh && \
    kubectl completion bash > /etc/profile.d/kubectl.sh

COPY entrypoint.sh /entrypoint.sh
EXPOSE 8080 8081

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
