# Based on https://github.com/roboll/helmfile/blob/master/Dockerfile.helm3
FROM alpine:3.11

RUN apk add --no-cache ca-certificates git bash curl jq python openssh-client

ARG HELM_VERSION=v3.2.1
ARG HELM_LOCATION="https://get.helm.sh"
ARG HELM_FILENAME="helm-${HELM_VERSION}-linux-amd64.tar.gz"
ARG HELM_SHA256="018f9908cb950701a5d59e757653a790c66d8eda288625dbb185354ca6f41f6b"
RUN wget ${HELM_LOCATION}/${HELM_FILENAME} && \
    echo Verifying ${HELM_FILENAME}... && \
    sha256sum ${HELM_FILENAME} | grep -q "${HELM_SHA256}" && \
    echo Extracting ${HELM_FILENAME}... && \
    tar zxvf ${HELM_FILENAME} && mv /linux-amd64/helm /usr/local/bin/ && \
    rm ${HELM_FILENAME} && rm -r /linux-amd64

ARG HELM_S3_VERSION=v0.9.2

RUN helm plugin install https://github.com/hypnoglow/helm-s3.git --version ${HELM_S3_VERSION}

CMD /usr/local/bin/helm
