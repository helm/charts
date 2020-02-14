chart_path="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
helm_render() {
  helm install dry-run "${chart_path}" --dry-run -f "${chart_path}"/test/enable-all-images.yaml "$@"
}

# Image pull secrets

T_noImagePullSecretsByDefault() {
  result="$(helm_render | grep -c "imagePullSecrets")"
  [[ $result -eq 0 ]]
}

T_globalImagePullSecrets() {
  result="$(helm_render -f "$chart_path/test/global/imagePullSecrets.yaml" |
     grep -A1 "imagePullSecrets:" | grep -c "name: nunquam-manifestum-fortis")"
  [[ $result -eq 2 ]]
}

T_chartImagePullSecrets() {
  result="$(helm_render -f "$chart_path/test/chart/imagePullSecrets.yaml" |
    grep -A1 "imagePullSecrets:" | grep -c "name: ionic-cannon-at-the-port")"
  [[ $result -eq 2 ]]
}

T_singleImagePullSecret() {
  result="$(helm_render -f "$chart_path/test/single/imagePullSecret.yaml" |
    grep -A1 "imagePullSecrets:" | grep -c "name: grilling-the-garlics")"
  [[ $result -eq 2 ]]
}

T_allSecretsAreCombined() {
  result="$(helm_render -f "$chart_path/test/global/imagePullSecrets.yaml" \
    -f "$chart_path/test/chart/imagePullSecrets.yaml" \
    -f "$chart_path/test/single/imagePullSecret.yaml" |
    grep -A3 "imagePullSecrets:" | grep -c -E "name: (nunquam|ionic|grilling)")"
  [[ $result -eq 6 ]]
}

# Image registry
T_originalImageRegistry() {
  result="$(helm_render | grep -c "image: docker.io")"
  [[ $result -eq 5 ]]
}

T_globalImageRegistry() {
  result="$(helm_render -f "$chart_path/test/global/imageRegistry.yaml" | grep -c "image: shaking.the.strawberries")"
  [[ $result -eq 5 ]]
}

T_chartImageRegistry() {
  result="$(helm_render -f "$chart_path/test/chart/imageRegistry.yaml" | grep -c "image: joy.is.local")"
  [[ $result -eq 5 ]]
}

T_chartImageRegistryOverridesGlobal() {
  output="$(helm_render -f "$chart_path/test/chart/imageRegistry.yaml" -f "$chart_path/test/global/imageRegistry.yaml")"
  export output
  global_image_count="$(echo "${output}" | grep -c "image: shaking.the.strawberries/bitnami/")"
  chart_image_count="$(echo "${output}" | grep -c "image: joy.is.local/bitnami/")"
  [[ $global_image_count -eq 0 ]] && [[ $chart_image_count -eq 5 ]]
}

T_useOriginalRegistryOverridesGlobalAndChartSettings() {
  output="$(helm_render -f "$chart_path/test/chart/imageRegistry.yaml" -f "$chart_path/test/global/imageRegistry.yaml" \
    -f "$chart_path/test/original/registry.yaml")"
  export output
  global_image_count="$(echo "${output}" | grep -c "image: shaking.the.strawberries/bitnami/")"
  chart_image_count="$(echo "${output}" | grep -c "image: joy.is.local/bitnami/")"
  original_image_count="$(echo "${output}" | grep -c "image: docker.io/bitnami/postgres-exporter:")"
  [[ $global_image_count -eq 0 ]] && [[ $chart_image_count -eq 4 ]] && [[ $original_image_count -eq 1 ]]
}

T_singleImageRegistry() {
  result="$(helm_render -f "$chart_path/test/single/imageRegistry.yaml" | grep -c "image: lixa.hippotoxota.zelus/bitnami/postgresql")"
  [[ $result -eq 2 ]]
}

T_singleImageRegistryKeepsRegistryForOtherImages() {
  result="$(helm_render -f "$chart_path/test/single/imageRegistry.yaml" | grep -c "image: docker.io")"
  [[ $result -eq 3 ]]
}

T_singleOriginalImageRegistry() {
  result="$(helm_render -f "$chart_path/test/global/imageRegistry.yaml" \
    -f "$chart_path/test/original/registry.yaml" | grep -c "image: docker.io/bitnami/postgres-exporter")"
  [[ $result -eq 1 ]]
}

T_singleOriginalImageRegistryKeepsRegistryForOtherImages() {
  result="$(helm_render -f "$chart_path/test/global/imageRegistry.yaml" \
    -f "$chart_path/test/original/registry.yaml" | grep -c "image: shaking.the.strawberries")"
  [[ $result -eq 4 ]]
}

# Image namespace
T_originalImageNamespace() {
  result="$(helm_render | grep -c "image: docker.io/bitnami")"
  [[ $result -eq 5 ]]
}

T_globalImageNamespace() {
  result="$(helm_render -f "$chart_path/test/global/imageNamespace.yaml" | grep -c "image: docker.io/mario")"
  [[ $result -eq 5 ]]
}

T_chartImageNamespace() {
  result="$(helm_render -f "$chart_path/test/chart/imageNamespace.yaml" | grep -c "image: docker.io/portdegas")"
  [[ $result -eq 5 ]]
}

T_singleImageNamespace() {
  result="$(helm_render -f "$chart_path/test/single/imageNamespace.yaml" | grep -c "image: docker.io/cabbage/postgres-exporter")"
  [[ $result -eq 1 ]]
}

T_singleImageNamespaceKeepsNamespaceForOtherImages() {
  result="$(helm_render -f "$chart_path/test/single/imageNamespace.yaml" | grep -c "image: docker.io/bitnami")"
  [[ $result -eq 4 ]]
}

T_singleOriginalImageNamespace() {
  result="$(helm_render -f "$chart_path/test/global/imageNamespace.yaml" \
    -f "$chart_path/test/original/namespace.yaml" | grep -c "image: docker.io/bitnami")"
  [[ $result -eq 1 ]]
}

T_singleOriginalImageNamespaceKeepsNamespaceForOtherImages() {
  result="$(helm_render -f "$chart_path/test/global/imageNamespace.yaml" \
    -f "$chart_path/test/original/namespace.yaml" | grep -c "image: docker.io/mario")"
  [[ $result -eq 4 ]]
}

T_chartImageNamespaceOverridesGlobal() {
  output="$(helm_render -f "$chart_path/test/chart/imageNamespace.yaml" -f "$chart_path/test/global/imageNamespace.yaml")"
  export output
  global_image_count="$(echo "${output}" | grep -c "image: docker.io/mario/")"
  chart_image_count="$(echo "${output}" | grep -c "image: docker.io/portdegas/")"
  [[ $global_image_count -eq 0 ]] && [[ $chart_image_count -eq 5 ]]
}

# Image pull policy
T_imagePullPolicyIsNotSpecifiedByDefault() {
  result_all="$(helm_render | grep -A1 "image: docker.io" | grep -c 'imagePullPolicy: "Always"')"
  result_minideb="$(helm_render | grep -A1 "image: docker.io/bitnami/minideb" | grep -c 'imagePullPolicy: "Always"')"
  [[ $result_all -eq 2 ]] && [[ $result_minideb -eq 2 ]]
}

T_globalImagePullPolicy() {
  result="$(helm_render -f "$chart_path/test/global/imagePullPolicy.yaml" | grep -A1 "image: docker.io" |
    grep -c 'imagePullPolicy: "Always"')"
  [[ $result -eq 5 ]]
}

T_chartImagePullPolicy() {
  result="$(helm_render -f "$chart_path/test/chart/imagePullPolicy.yaml" | grep -A1 "image: docker.io" |
    grep -c 'imagePullPolicy: "Never"')"
  [[ $result -eq 3 ]]
}

T_singleImagePullPolicy() {
  result="$(helm_render -f "$chart_path/test/single/imagePullPolicy.yaml" | grep -A1 "image: docker.io/bitnami/postgresql" |
    grep -c 'imagePullPolicy: "IfNotPresent"')"
  [[ $result -eq 2 ]]
}