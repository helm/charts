# Zulip

[Zulip](https://zulipchat.com/), the world's most productive chat

Helm chart based on https://github.com/galexrt/docker-zulip

## Installation

Grab a copy of values.yaml, modify it as necessary, then install with `helm install -f value.yaml incubator/zulip`

After installation you will need to run `/opt/createZulipRealm.sh`.   Instructions for doing so should be printed out during installation.
