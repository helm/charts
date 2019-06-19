#!/usr/bin/env bash
cat values.yaml | sed 's/cleanupCustomResource: false/cleanupCustomResource: true/' > ci/test-values.yaml