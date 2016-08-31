#!/bin/bash -xe
docker run -v `pwd`:/src gcr.io/kubernetes-charts-ci/test-image:v1.4 /src/test/changed.sh
echo "Done Testing!"
