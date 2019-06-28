#!/usr/bin/env bash
sed -e 's/cleanupCustomResource: false/cleanupCustomResource: true/' \
	-e 's/cleanupCustomResourceBeforeInstall: false/cleanupCustomResourceBeforeInstall: true/' \
	values.yaml > ci/test-values.yaml
