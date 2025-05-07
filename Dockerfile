# Dockerfile for k8s-toolkit on UBI 9 (compatible with Kubernetes & OpenShift)
FROM registry.access.redhat.com/ubi9/ubi:latest

LABEL maintainer="lorenzo.biosa@yahoo.it" \
      version="1.0" \
      description="All-in-one troubleshooting toolkit for Kubernetes & OpenShift (UBI)"

USER root
WORKDIR /root

# Install software
RUN dnf update -y && \
    dnf install -y tar gzip bind-utils iputils man mtr net-tools nmap-ncat procps wget && \
    dnf clean all

# Install kubectl (latest stable patch)
RUN curl -fsSL -o /usr/local/bin/kubectl \
    https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl

# Install jq
ARG JQ_VERSION=1.7.1
RUN curl -fsSL -o /usr/local/bin/jq \
      https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
    chmod +x /usr/local/bin/jq

# Install OpenShift CLI (latest stable patch)
RUN curl -fsSL -o /tmp/oc.tar.gz \
    https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-client-linux.tar.gz && \
    tar -xzf /tmp/oc.tar.gz -C /usr/local/bin oc && \
    chmod +x /usr/local/bin/oc && \
    rm /tmp/oc.tar.gz

ENTRYPOINT ["/bin/bash"]
CMD ["-l"]
