#!/usr/bin/env bash

sed \
  -e 's/cleanupCrdsBeforeInstall: false/cleanupCrdsBeforeInstall: true/' \
  values.yaml > ci/test-values.yaml
