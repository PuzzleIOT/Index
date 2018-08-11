echo ""
echo "Creating garden switch configuration"
echo ""

# Example:
# sh create-switch.sh [Label] [DeviceName] [Port]
# sh create-switch.sh "Switch1" switch1 ttyUSB0 

DIR=$PWD

DEVICE_LABEL=$1
DEVICE_NAME=$2
DEVICE_PIN=$3
DEVICE_PORT=$4

if [ ! $DEVICE_LABEL ]; then
  DEVICE_LABEL="Switch1"
fi

if [ ! $DEVICE_NAME ]; then
  DEVICE_NAME="switch1"
fi

if [ ! $DEVICE_PIN ]; then
  DEVICE_PIN="13"
fi

if [ ! $DEVICE_PORT ]; then
  DEVICE_PORT="ttyUSB0"
fi

echo "Device label: $DEVICE_LABEL"
echo "Device name: $DEVICE_NAME"
echo "Device pin: $DEVICE_PIN"
echo "Device port: $DEVICE_PORT"

# Set up mobile UI
sh create-switch-ui.sh $DEVICE_LABEL $DEVICE_NAME $DEVICE_PIN $DEVICE_PORT && \

# Create device info
sh create-device-pin-info.sh switch/NetSwitch $DEVICE_LABEL $DEVICE_NAME $DEVICE_PIN $DEVICE_PORT && \

# Set up MQTT bridge service
sh create-switch-mqtt-bridge-service.sh $DEVICE_NAME $DEVICE_PIN $DEVICE_PORT && \

# Set up update service
sh create-updater-service.sh switch nano $DEVICE_NAME $DEVICE_PORT && \

# Uploading sketch
#sh upload-switch-nano-sketch.sh $DEVICE_PORT && \

echo "Puzzle switch created with device name '$DEVICE_NAME'"
