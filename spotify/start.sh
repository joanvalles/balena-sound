#!/usr/bin/env bash

# Set the device broadcast name for Spotify
if [[ -z "$BLUETOOTH_DEVICE_NAME" ]]; then
  BLUETOOTH_DEVICE_NAME=$(printf "balenaSound %s" $(hostname | cut -c -4))
fi

# Set the system volume here
SYSTEM_OUTPUT_VOLUME="${SYSTEM_OUTPUT_VOLUME:-100}"

# Set the Spotify username and password
if [ ! -z "$SPOTIFY_LOGIN" ] && [ ! -z "$SPOTIFY_PASSWORD" ]; then
  SPOTIFY_CREDENTIALS="--username $SPOTIFY_LOGIN --password $SPOTIFY_PASSWORD"
  printf "%s\n" "Using Spotify login."
fi

# Use pipe backend if multi room is enabled
if [[ -z $DISABLE_MULTI_ROOM ]]; then
  SPOTIFY_BACKEND="--backend pipe"
  SPOTIFY_DEVICE="--device /var/cache/snapcast/snapfifo"
fi

# Start raspotify
exec /usr/bin/librespot --name "$BLUETOOTH_DEVICE_NAME" $SPOTIFY_BACKEND --bitrate 320 --cache /var/cache/raspotify --enable-volume-normalisation --linear-volume --initial-volume=$SYSTEM_OUTPUT_VOLUME $SPOTIFY_CREDENTIALS $SPOTIFY_DEVICE