# Copyright 2016 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM golang

RUN git clone https://github.com/kubernetes/contrib.git \
 && cd contrib/peer-finder \
 && go get k8s.io/apimachinery/pkg/util/sets \
 && make server

FROM alpine:3.4
MAINTAINER Anirudh Ramanathan <foxish@google.com>

RUN apk update && apk add bash openssl

COPY --from=0 /go/contrib/peer-finder/peer-finder /peer-finder

ENTRYPOINT ["/install.sh"]

ADD files/* /

RUN chmod -c 755 /install.sh /on-start.sh /peer-finder
