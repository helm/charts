FROM apache/nifi-toolkit:1.6.0

ARG KUBECTL_VERSION=v1.10.3

RUN curl -L -o ${NIFI_TOOLKIT_BASE_DIR}/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    && chmod +x ${NIFI_TOOLKIT_BASE_DIR}/kubectl

COPY generate.sh ${NIFI_TOOLKIT_BASE_DIR}/generate.sh

ENTRYPOINT ${NIFI_TOOLKIT_BASE_DIR}/generate.sh