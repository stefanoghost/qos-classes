#!/bin/bash
while [ ! -f /root/scenario/verify.sh ]; do
  sleep 1
done

echo "Scenario pronto."
echo "Vai in /root/scenario e applica i manifest."
