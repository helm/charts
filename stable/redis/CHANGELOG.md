
# 4.0.0

* introduce `existingSecret` map to map the redis password from a external provided secret
* drop `existingSecret` from values.yaml (you can use `secretKeyRefs` to achieve the same goal)
