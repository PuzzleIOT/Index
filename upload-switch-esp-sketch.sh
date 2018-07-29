
# Example:
# sh upload-switch-sketch-esp.sh "myswitch" ttyUSB0

DIR=$PWD

. ./common-test-flags.sh

DEVICE_NAME=$1
SERIAL_PORT=$2

if [ ! $SERIAL_PORT ]; then
  SERIAL_PORT="ttyUSB0"
fi

if [ ! $DEVICE_NAME ]; then
  echo "Specify the device name as an argument."
  exit 1
fi

echo "Uploading switch ESP8266 sketch"

echo "Serial port: $SERIAL_PORT"

BASE_PATH="sketches/switch/NetSwitchESP"

cd $BASE_PATH

# Pull the security files from the index into the project
sh pull-security-files.sh && \

# Inject security details
sh inject-security-settings.sh && \

# Inject device name
sh inject-device-name.sh "$DEVICE_NAME" && \

# Inject version into the sketch
sh inject-version.sh && \

# Build the sketch
if [ $IS_MOCK_SUBMODULE_BUILDS = 0 ]; then
    sh build.sh || exit 1
else
    echo "[mock] sh build.sh"
fi


# Upload the sketch
if [ $IS_MOCK_HARDWARE = 0 ]; then
    sh upload.sh "/dev/$SERIAL_PORT" || exit 1
else
    echo "[mock] sh upload.sh /dev/$SERIAL_PORT"
fi

# Clean all settings
sh clean-settings.sh && \

cd $DIR && \

if [ $IS_MOCK_HARDWARE = 0 ]; then
    sh $BASE_PATH/monitor-serial.sh "/dev/$SERIAL_PORT" || exit 1
else
    echo "[mock] sh monitor-serial.sh /dev/$SERIAL_PORT"
fi

echo "Finished upload"
