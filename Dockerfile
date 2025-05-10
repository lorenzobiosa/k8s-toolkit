# Dockerfile for k8s-toolkit on UBI 9 (compatible with Kubernetes & OpenShift)
FROM almalinux:latest

LABEL maintainer="lorenzo.biosa@yahoo.it" \
      version="1.0" \
      description="All-in-one troubleshooting toolkit for Kubernetes & OpenShift (UBI)"

USER root
WORKDIR /root

# Install software
RUN dnf update -y && dnf install -y epel-release && \
    dnf install -y bash-completion bind-utils gzip htop iotop iputils \
        man mtr net-tools nmap-ncat openssh-clients procps sysstat tar telnet tmux traceroute ttyd wget && \
    dnf clean all

# Install kubectl (latest stable patch)
RUN curl -fsSL -o /usr/local/bin/kubectl \
    https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl

# Install OpenShift CLI (latest stable patch)
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

# Install jq
ARG JQ_VERSION=1.7.1
RUN curl -fsSL -o /usr/local/bin/jq \
    https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
    chmod +x /usr/local/bin/jq

# Install ttyd
ARG TTYD_VERSION=1.7.7
RUN curl -fsSL -o /usr/local/bin/ttyd \
    https://github.com/tsl0922/ttyd/releases/download/${TTYD_VERSION}/ttyd.x86_64 && \
    chmod +x /usr/local/bin/ttyd

COPY entrypoint.sh /entrypoint.sh
RUN mkdir /www
EXPOSE 8080 8081
ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
