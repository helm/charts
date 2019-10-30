#!/usr/bin/env bash
sed \
	-e 's/createCustomResource: true/createCustomResource: false/' \
	-e 's/port: 9100/port: 9101/' \
	-e 's/targetPort: 9100/targetPort: 9101/' \
  values.yaml > ci/02-test-without-crds-values.yaml
