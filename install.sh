#!/bin/bash

PLUGIN_PATH="${HOME}/.kube/plugins"
mkdir -p "${PLUGIN_PATH}"

plugins=( skipper )

for p in "${plugins[@]}"
do
  cp -r ${p} "${PLUGIN_PATH}"
done
