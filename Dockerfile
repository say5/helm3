# Based on https://github.com/roboll/helmfile/blob/master/Dockerfile.helm3
FROM alpine:3.14

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories 

RUN apk add --update --no-cache ca-certificates git bash curl jq python3 openssh-client yq

ARG HELM_VERSION=v3.7.0
ARG HELM_LOCATION="https://get.helm.sh"
ARG HELM_FILENAME="helm-${HELM_VERSION}-linux-amd64.tar.gz"
ARG HELM_SHA256="096e30f54c3ccdabe30a8093f8e128dba76bb67af697b85db6ed0453a2701bf9"
RUN wget ${HELM_LOCATION}/${HELM_FILENAME} && \
    echo Verifying ${HELM_FILENAME}... && \
    sha256sum ${HELM_FILENAME} | grep -q "${HELM_SHA256}" && \
    echo Extracting ${HELM_FILENAME}... && \
    tar zxvf ${HELM_FILENAME} && mv /linux-amd64/helm /usr/local/bin/ && \
    rm ${HELM_FILENAME} && rm -r /linux-amd64

ARG HELM_S3_VERSION=v0.10.0
RUN helm plugin install https://github.com/hypnoglow/helm-s3.git --version ${HELM_S3_VERSION}

ARG LINKERD2_VERSION=stable-2.10.2
ARG LINKERD2_SHA256="7021232b50368b247e8d5226d381a654327f610c4f61d6719dc6fd6e46284035"
ARG LINKERD2_FILENAME=linkerd2-cli-${LINKERD2_VERSION}-linux-amd64


RUN wget https://github.com/linkerd/linkerd2/releases/download/${LINKERD2_VERSION}/${LINKERD2_FILENAME}  && \
    echo Verifying ${LINKERD2_FILENAME}... && \
    sha256sum ${LINKERD2_FILENAME} | grep -q "${LINKERD2_SHA256}" && \
    chmod 755 ${LINKERD2_FILENAME} && \
    mv ${LINKERD2_FILENAME} /usr/local/bin/linkerd

CMD /usr/local/bin/helm
