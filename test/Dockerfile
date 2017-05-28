# Copyright 2016 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM debian:8.5

ENV CLOUDSDK_CORE_DISABLE_PROMPTS=1 \
  PATH=/opt/google-cloud-sdk/bin:$PATH \
  GOOGLE_CLOUD_SDK_VERSION=154.0.0 \
  GOOGLE_PROJECT=kubernetes-charts-ci

RUN set -x \
  && cd /opt \
  && echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
  && apt-get update \
  && apt-get install --no-install-recommends -y jq wget python git localepurge ca-certificates \
  && wget -q https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GOOGLE_CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
  && tar zxfv google-cloud-sdk-${GOOGLE_CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
  && ./google-cloud-sdk/install.sh \
  && gcloud components install kubectl \
  && gcloud config set project ${GOOGLE_PROJECT}
RUN apt-get -y purge localepurge \
  && apt-get clean \
  && cd / \
  && rm -rf \
     /opt/google-cloud-sdk-${GOOGLE_CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
     /opt/helm-${HELM_VERSION}-linux-amd64.tar.gz \
     doc \
     man \
     info \
     locale \
     /var/lib/apt/lists/* \
     /var/log/* \
     /var/cache/debconf/* \
     common-licenses \
     ~/.bashrc \
     /etc/systemd \
     /lib/lsb \
     /lib/udev \
     /usr/share/doc/ \
     /usr/share/doc-base/ \
     /usr/share/man/ \
     /tmp/*

VOLUME "/src"
WORKDIR "/src"
