#!/bin/bash

IMAGE=${1:-raspberry.img}

MMC='/dev/mmcblk0'

#------------------------------------------------------------------------
# Ask a question and return 0 (yes) or 1 (false).
#------------------------------------------------------------------------

function ask() {
  echo -n "${1} "
  read -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    return 0
  fi
  return 1
}

if [ -f ${IMAGE} ]; then
  echo
  echo "ready to write image to ${MMC} from '${IMAGE}'"
  echo
  if ask 'write image? [y/N]:'; then
    echo
    echo 'writing image...'
    echo
    time sudo dd if=${IMAGE} of=${MMC} bs=64K status=progress
    echo
    ls -lh ${IMAGE}
    echo
    echo '#############################################'
    echo '###                 DONE                  ###'
    echo '#############################################'
  fi
else
  echo
  echo "*** image ${IMAGE} not found!"
fi
echo

