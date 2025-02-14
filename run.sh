#!/bin/bash

# Allow local connections to the X server for GUI applications in Docker
xhost +local:

# Setup for X11 forwarding to enable GUI
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

IMAGE_NAME=delora:latest

HOST_FOLDER_PATH="$(pwd)"

CONTAINER_FOLDER_PATH="/root/delora"

# Run the Docker container with the selected image and configurations for GUI applications
docker run -it \
  --rm \
  --name=delora_container \
  --user=root \
  --privileged \
  --network=host \
  --env="DISPLAY=$DISPLAY" \
  --env="QT_X11_NO_MITSHM=1" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  --env="XAUTHORITY=$XAUTH" \
  --volume="$XAUTH:$XAUTH" \
  --env="NVIDIA_VISIBLE_DEVICES=all" \
  --env="NVIDIA_DRIVER_CAPABILITIES=all" \
  --runtime nvidia \
  -v "$HOST_FOLDER_PATH:$CONTAINER_FOLDER_PATH:rw" \
  $IMAGE_NAME

# Notes:
# - The script assumes a certain level of trust with the containers being run, especially with options like --privileged and X11 forwarding.
# - Consider enhancing security measures and validating input paths for better safety in production environments.
