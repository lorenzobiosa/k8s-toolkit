# Dockerfile for k8s-toolkit on UBI 9 (compatible with Kubernetes & OpenShift)
FROM registry.access.redhat.com/ubi9/ubi-minimal:latest

LABEL maintainer="lorenzo.biosa@yahoo.it" \
      version="1.0" \
      description="All-in-one troubleshooting toolkit for Kubernetes & OpenShift (UBI 9)"

USER root

# 1) Install curl to fetch binaries, then remove it to keep image minimal
RUN microdnf install -y curl && \
    microdnf clean all

# 2) Install kubectl (latest stable patch)  
ARG KUBECTL_VERSION=v1.28.6  
RUN curl -fsSL -o /usr/local/bin/kubectl \
      https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl

# 3) Install jq  
ARG JQ_VERSION=1.6  
RUN curl -fsSL -o /usr/local/bin/jq \
      https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
    chmod +x /usr/local/bin/jq

# 4) Install OpenShift CLI (oc)  
ARG OC_VERSION=4.13.0  
RUN curl -fsSL -o /tmp/oc.tar.gz \
      https://mirror.openshift.com/pub/openshift-v4/clients/oc/${OC_VERSION}/openshift-client-linux-${OC_VERSION}.tar.gz && \
    tar -xzf /tmp/oc.tar.gz -C /usr/local/bin oc && \
    chmod +x /usr/local/bin/oc && \
    rm /tmp/oc.tar.gz

# 5) Clean up curl  
RUN microdnf remove -y curl && \
    microdnf clean all

# 6) Create non-root user for OpenShift  
RUN groupadd -r toolkit && useradd -r -g toolkit -d /home/toolkit -m toolkit && \
    mkdir -p /opt/toolkit && \
    chown -R toolkit:toolkit /home/toolkit /opt/toolkit

USER toolkit  
WORKDIR /home/toolkit

ENTRYPOINT ["/bin/bash"]  
CMD ["-l"]
