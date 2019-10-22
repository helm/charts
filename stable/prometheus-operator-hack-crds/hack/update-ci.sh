#!/usr/bin/env bash
sed \
  -e 's/cleanupCustomResource: false/cleanupCustomResource: true/' \
	-e 's/cleanupCustomResourceBeforeInstall: false/cleanupCustomResourceBeforeInstall: true/' \
	-e 's/port: 9100/port: 9101/' \
	-e 's/targetPort: 9100/targetPort: 9101/' \
  values.yaml > ci/test-values.yaml
