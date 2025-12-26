# Based on https://github.com/roboll/helmfile/blob/master/Dockerfile.helm3
FROM alpine:3.21

ENV HELM_EXPERIMENTAL_OCI=1

RUN apk add --update --no-cache ca-certificates git bash curl jq python3 openssh-client yq aws-cli

ARG HELM_VERSION=v3.19.4
ARG HELM_LOCATION="https://get.helm.sh"
ARG HELM_FILENAME="helm-${HELM_VERSION}-linux-amd64.tar.gz"
ARG HELM_SHA256="759c656fbd9c11e6a47784ecbeac6ad1eb16a9e76d202e51163ab78504848862"
RUN wget ${HELM_LOCATION}/${HELM_FILENAME} && \
    echo Verifying ${HELM_FILENAME}... && \
    sha256sum ${HELM_FILENAME} | grep -q "${HELM_SHA256}" && \
    echo Extracting ${HELM_FILENAME}... && \
    tar zxvf ${HELM_FILENAME} && mv /linux-amd64/helm /usr/local/bin/ && \
    rm ${HELM_FILENAME} && rm -r /linux-amd64

ARG HELM_S3_VERSION=v0.17.1
RUN helm plugin install https://github.com/hypnoglow/helm-s3.git --version ${HELM_S3_VERSION}


CMD ["/usr/local/bin/helm"]
