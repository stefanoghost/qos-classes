#!/bin/bash

NODE="node01"

STATUS=$(kubectl get node $NODE -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null)
VERSION=$(kubectl get node $NODE -o jsonpath='{.status.nodeInfo.kubeletVersion}' 2>/dev/null)

if [[ "$STATUS" == "True" && "$VERSION" == "v1.34.1" ]]; then
  echo "✅ Step1 completed successfully"
  exit 0
else
  echo "❌ Step1 failed"
  echo "Node status: $STATUS"
  echo "Node version: $VERSION"
  exit 1
fi
