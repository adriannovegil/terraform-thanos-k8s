prometheus:
  prometheusSpec:
    retention: ${retention}
    thanos:
      image: quay.io/thanos/thanos:v0.17.2
      version: v0.17.2
      objectStorageConfig:
        name: thanos
        key: object-store.yaml
    externalLabels:
      cluster: thanos-operator-test
