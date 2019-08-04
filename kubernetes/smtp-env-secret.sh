#!/usr/bin/env bash

# Put your password in a file called smtp-relay-password
echo "---
apiVersion: v1
kind: Secret
metadata:
  name: smtp-relay-env
data:
  smtp-relay-password: `base64 smtp-relay-password`
" | kubectl create -f -
