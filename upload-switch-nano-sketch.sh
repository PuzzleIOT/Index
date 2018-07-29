
# Example:
# sh upload-switch-sketch.sh ttyUSB0

DIR=$PWD

. ./common-test-flags.sh

SERIAL_PORT=$1

if [ ! $SERIAL_PORT ]; then
  SERIAL_PORT="ttyUSB0"
fi

echo "Uploading switch sketch"

echo "Serial port: $SERIAL_PORT"

BASE_PATH="sketches/switch/NetSwitch"

cd $BASE_PATH

SKETCH_PATH="src/NetSwitch/NetSwitch.ino"

# Inject version into the sketch
sh inject-version.sh && \

# Build the sketch
if [ $IS_MOCK_SUBMODULE_BUILDS = 0 ]; then
    sh build-nano.sh || exit 1
else
    echo "[mock] sh build-uno.sh"
fi

# Upload the sketch
if [ $IS_MOCK_HARDWARE = 0 ]; then
    sh upload-nano.sh "/dev/$SERIAL_PORT" || exit 1
else
    echo "[mock] sh upload-nano.sh /dev/$SERIAL_PORT"
fi

cd $DIR

if [ $IS_MOCK_HARDWARE = 0 ]; then
    sh $BASE_PATH/monitor-serial.sh "/dev/$SERIAL_PORT" || exit 1
else
    echo "[mock] sh monitor-serial.sh /dev/$SERIAL_PORT"
fi

echo "Finished upload"

