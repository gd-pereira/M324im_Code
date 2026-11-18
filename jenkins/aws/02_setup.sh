#!/usr/bin/bash
# Builds the three images (each FROM the previous one). Run on the EC2 instance.
PARAMS='01_params.sh'
if [ ! -f "$PARAMS" ]; then echo "$PARAMS does not exist!"; exit 1; fi
source "$PARAMS"
if [ "$user" = "CHANGE_ME" ]; then echo "Set DOCKERHUB_USER first"; exit 1; fi

function buildImage() {
  local image=$1 file=$2 base=$3
  echo "build $image from $file"
  docker build -t "$image" -f "$file" ${base:+--build-arg IMG=$base} . || exit 1
}
buildImage "${image1}" "${file1}"
buildImage "${image2}" "${file2}" "${image1}"
buildImage "${image3}" "${file3}" "${image2}"
docker image ls
