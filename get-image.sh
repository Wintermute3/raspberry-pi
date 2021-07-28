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

echo
echo "ready to read image from ${MMC} into '${IMAGE}'"

echo
if ask 'read image? [y/N]:'; then
  echo
  echo 'reading image...'
  echo
  time sudo dd if=${MMC} of=${IMAGE} bs=64K status=progress
  echo
  ls -lh ${IMAGE}
  echo
  echo '#############################################'
  echo '###                 DONE                  ###'
  echo '#############################################'
fi

if [ -f ${IMAGE} ]; then
  echo
  if ask 'shrink image? [y/N]:'; then
    if [ ! -f pishrink.sh ]; then
      echo
      echo 'pishrink.sh not found, downloading...'
      echo
      wget https://raw.githubusercontent.com/Drewsif/PiShrink/master/pishrink.sh
      chmod +x pishrink.sh
    fi
    if [ -f pishrink.sh ]; then
      echo
      echo 'shrinking image...'
      echo
      time sudo ./pishrink.sh ${IMAGE}
      echo
      ls -lh ${IMAGE}
      echo
      echo '#############################################'
      echo '###                 DONE                  ###'
      echo '#############################################'
    else
      echo '*** pishrink.sh not found!'
    fi
  fi
else
  echo
  echo "*** image ${IMAGE} not found!"
fi
echo
