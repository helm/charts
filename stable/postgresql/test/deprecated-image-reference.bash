chart_path="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
helm_full_manifest="helm install dry-run ${chart_path} --dry-run -f ${chart_path}/test/enable-all-images.yaml"


T_deprecatedImageRepository() {
  result="$($helm_full_manifest -f "$chart_path/test/deprecated/image.yaml" | grep -c "image: docker.io/shining/moonlight:some-tag")"
  [[ $result -eq 2 ]]
}

T_deprecatedImageReferenceExcludesTheDigest() {
  result="$($helm_full_manifest -f "$chart_path/test/deprecated/image.yaml" | grep -c "image: docker.io/shining/moonlight:some-tag@")"
  [[ $result -eq 0 ]]
}

T_conventionalReferencesAreUsedForOtherImages() {
  result="$($helm_full_manifest -f "$chart_path/test/deprecated/image.yaml" |
    grep -c "image: docker.io/bitnami/postgres-exporter:some-other-tag@sha256:50b42a053f5260991169c211fa7df5ca0a1f5ffd924ba826a8869f489c2ea853")"
  [[ $result -eq 1 ]]
}

T_deprecatedImageTag() {
  result="$($helm_full_manifest -f "$chart_path/test/deprecated/tag.yaml" | grep -c "image: docker.io/bitnami/postgresql:port-royal")"
  [[ $result -eq 2 ]]
}

T_deprecatedImageRegistry() {
  result="$($helm_full_manifest -f "$chart_path/test/deprecated/registry.yaml" | grep -c "image: believer.io/bitnami/postgresql:some-tag")"
  [[ $result -eq 2 ]]
}

T_deprecatedImagePullPolicy() {
  result="$($helm_full_manifest -f "$chart_path/test/deprecated/imagePullPolicy.yaml" |
    grep -A1 "image: docker.io/bitnami/postgresql:some-tag" | grep -c 'imagePullPolicy: "Never"')"
  [[ $result -eq 2 ]]
}

T_deprecatedImagePullSecrets() {
  result="$($helm_full_manifest -f "$chart_path/test/deprecated/imagePullSecrets.yaml" |
    grep -A1 "imagePullSecrets:" | grep -c 'name: Never-praise-the-self')"
  [[ $result -eq 2 ]]
}