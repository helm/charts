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

ENV CLOUDSDK_CORE_DISABLE_PROMPTS 1
ENV PATH $WORKDIR/google-cloud-sdk/bin:$PATH
ENV HELM_VERSION=v2.0.0-alpha.3
ENV GOOGLE_CLOUD_SDK_VERSION=123.0.0
ENV GOOGLE_PROJECT=kubernetes-charts-ci

WORKDIR /opt
RUN apt-get update -y
RUN apt-get install -y jq wget python git
RUN wget -q https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GOOGLE_CLOUD_SDK_VERSION}-linux-x86_64.tar.gz
RUN tar zxfv google-cloud-sdk-${GOOGLE_CLOUD_SDK_VERSION}-linux-x86_64.tar.gz
RUN ./google-cloud-sdk/install.sh
ENV PATH /opt/google-cloud-sdk/bin:$PATH
RUN gcloud components install kubectl
RUN gcloud config set project ${GOOGLE_PROJECT}


RUN wget https://storage.googleapis.com/kubernetes-charts-ci/helm/helm-${HELM_VERSION}-linux-amd64.tar
RUN tar xfv helm-${HELM_VERSION}-linux-amd64.tar
ENV PATH /opt/linux-amd64/:$PATH
VOLUME /src
WORKDIR /src
