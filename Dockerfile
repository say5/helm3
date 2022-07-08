# Based on https://github.com/roboll/helmfile/blob/master/Dockerfile.helm3
FROM alpine:3.14

ENV HELM_EXPERIMENTAL_OCI=1

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories 
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk add --update --no-cache ca-certificates git bash curl jq python3 openssh-client yq aws-cli tmate

ARG HELM_VERSION=v3.9.0
ARG HELM_LOCATION="https://get.helm.sh"
ARG HELM_FILENAME="helm-${HELM_VERSION}-linux-amd64.tar.gz"
ARG HELM_SHA256="1484ffb0c7a608d8069470f48b88d729e88c41a1b6602f145231e8ea7b43b50a"
RUN wget ${HELM_LOCATION}/${HELM_FILENAME} && \
    echo Verifying ${HELM_FILENAME}... && \
    sha256sum ${HELM_FILENAME} | grep -q "${HELM_SHA256}" && \
    echo Extracting ${HELM_FILENAME}... && \
    tar zxvf ${HELM_FILENAME} && mv /linux-amd64/helm /usr/local/bin/ && \
    rm ${HELM_FILENAME} && rm -r /linux-amd64

ARG HELM_S3_VERSION=v0.12.0
RUN helm plugin install https://github.com/hypnoglow/helm-s3.git --version ${HELM_S3_VERSION}

ARG LINKERD2_VERSION=stable-2.11.3
ARG LINKERD2_SHA256="2a9ff195aae97c5a7ce938d106b4210f7a485764dd2ee118e0dad1bd569fc00f"
ARG LINKERD2_FILENAME=linkerd2-cli-${LINKERD2_VERSION}-linux-amd64


RUN wget https://github.com/linkerd/linkerd2/releases/download/${LINKERD2_VERSION}/${LINKERD2_FILENAME}  && \
    echo Verifying ${LINKERD2_FILENAME}... && \
    sha256sum ${LINKERD2_FILENAME} | grep -q "${LINKERD2_SHA256}" && \
    chmod 755 ${LINKERD2_FILENAME} && \
    mv ${LINKERD2_FILENAME} /usr/local/bin/linkerd

CMD /usr/local/bin/helm

