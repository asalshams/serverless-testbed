#!/bin/bash

RUNTIMES=("python" "nodejs" "go")
CPUS=("0.1" "0.2" "0.3" "0.4" "0.5" "0.6" "0.7" "0.8" "0.9" "1.0")
DOCKER_USER="asalshams"

for RUNTIME in "${RUNTIMES[@]}"; do
  for CPU in "${CPUS[@]}"; do
    CPU_NAME=$(echo $CPU | tr '.' '-')
    TEMPLATE="benchmark-project/${RUNTIME}/knative/template.yaml"

    cat $TEMPLATE | \
      sed "s/__RUNTIME__/${RUNTIME}/g" | \
      sed "s/__CPU_NAME__/${CPU_NAME}/g" | \
      sed "s/__CPU__/${CPU}/g" | \
      sed "s#__DOCKER_USER__#${DOCKER_USER}#g" | \
      kubectl apply -f -

    echo "✅ Deployed fibonacci-${RUNTIME}-${CPU_NAME} (CPU: ${CPU})"
  done
done
