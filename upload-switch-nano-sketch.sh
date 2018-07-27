
# Example:
# sh upload-switch-sketch.sh ttyUSB0

DIR=$PWD

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
sh build-nano.sh && \

# Upload the sketch
sh upload-nano.sh "/dev/$SERIAL_PORT"

cd $DIR

sh $BASE_PATH/monitor-serial.sh "/dev/$SERIAL_PORT"

