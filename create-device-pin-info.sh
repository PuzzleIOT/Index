
DEVICE_TYPE=$1
DEVICE_LABEL=$2
DEVICE_NAME=$3
DEVICE_PIN=$4
DEVICE_PORT=$5


EXAMPLE_TEXT="Example: sh create-device-pin-info.sh switch/NetSwitch Switch1 switch1 13 ttyUSB0"

if [ ! $DEVICE_TYPE ]; then
  echo "Device type must be specified as an argument."
  echo $EXAMPLE_TEXT
  exit 1
fi

if [ ! $DEVICE_LABEL ]; then
  echo "Device label must be specified as an argument."
  echo $EXAMPLE_TEXT
  exit 1
fi

if [ ! $DEVICE_NAME ]; then
  echo "Device name must be specified as an argument."
  echo $EXAMPLE_TEXT
  exit 1
fi

if [ ! $DEVICE_PIN ]; then
  echo "Device pin must be specified as an argument."
  echo $EXAMPLE_TEXT
  exit 1
fi

if [ ! $DEVICE_PORT ]; then
  echo "Device port must be specified as an argument."
  echo $EXAMPLE_TEXT
  exit 1
fi

echo "Device type: $DEVICE_TYPE"
echo "Device label: $DEVICE_LABEL"
echo "Device name: $DEVICE_NAME"
echo "Device pin: $DEVICE_PIN"
echo "Device port: $DEVICE_PORT"

DEVICES_DIR=$PWD/devices

mkdir -p  $DEVICES_DIR

DEVICE_DIR=$DEVICES_DIR/$DEVICE_NAME

mkdir -p $DEVICE_DIR

echo $DEVICE_TYPE > $DEVICE_DIR/type.txt
echo $DEVICE_LABEL > $DEVICE_DIR/label.txt
echo $DEVICE_NAME > $DEVICE_DIR/name.txt
echo $DEVICE_PIN > $DEVICE_DIR/pin.txt
echo $DEVICE_PORT > $DEVICE_DIR/port.txt

echo "Device pin info created"
