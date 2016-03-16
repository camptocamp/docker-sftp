#!/bin/bash
set -e

for type in rsa dsa ecdsa ed25519; do
  file=/etc/ssh/ssh_host_keys/ssh_host_${type}_key
  if [ ! -f $file ]; then
    ssh-keygen -q -f $file -N '' -t $type
    ssh-keygen -l -f $file.pub
  fi
done
