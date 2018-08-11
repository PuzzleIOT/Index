echo "Creating MQTT bridge service file..."

DEVICE_NAME=$1
DEVICE_PIN=$2
DEVICE_PORT=$3

if [ ! $DEVICE_NAME ]; then
    echo "Specify device name as an argument."
    exit 1
fi

if [ ! $DEVICE_PIN ]; then
    echo "Specify device pin as an argument."
    exit 1
fi

if [ ! $DEVICE_PORT ]; then
    echo "Specify device port as an argument."
    exit 1
fi

echo "Device name: $DEVICE_NAME"
echo "Device pin: $DEVICE_PIN"
echo "Device port: $DEVICE_PORT"

SERVICE_EXAMPLE_FILE="puzzleiot-mqtt-bridge-switch.service.example"
SERVICE_FILE="puzzleiot-mqtt-bridge-$DEVICE_PORT.service"
SERVICE_PATH="scripts/apps/BridgeArduinoSerialToMqttSplitCsv/svc"
SERVICE_FILE_PATH="$SERVICE_PATH/$SERVICE_FILE"
SERVICE_EXAMPLE_FILE_PATH="$SERVICE_PATH/$SERVICE_EXAMPLE_FILE"

echo "Example file:"
echo "$SERVICE_EXAMPLE_FILE_PATH"
echo "Service file:"
echo "$SERVICE_FILE_PATH"

echo "Copying service file..."

cp $SERVICE_EXAMPLE_FILE_PATH $SERVICE_FILE_PATH && \

echo "Editing service file..."

DEVICES_DIR="devices"

DIR=$PWD

DEVICE_NAMES=""
SUBSCRIBE_TOPICS=""

echo "Compiling subscribe topics..."

if [ -d "$DEVICES_DIR" ]; then
    for d in $DEVICES_DIR/*; do
        echo "Found device info:"
        echo $d
        DEVICE_INFO_PORT=$(cat $d/port.txt)
        echo "  Device info port: $DEVICE_INFO_PORT"
      
          
        if [ "$DEVICE_INFO_PORT" = "$DEVICE_PORT" ]; then
          DEVICE_INFO_NAME=$(cat $d/name.txt)
          DEVICE_INFO_PIN=$(cat $d/pin.txt)
          echo "  Device info name: $DEVICE_INFO_NAME"
          echo "  Device info pin: $DEVICE_INFO_PIN"

          if [ ! "$DEVICE_NAMES" ]; then      
            DEVICE_NAMES="$DEVICE_INFO_NAME"
          else
            DEVICE_NAMES="$DEVICE_NAMES,$DEVICE_INFO_NAME"
          fi
          
          if [ ! "$SUBSCRIBE_TOPICS" ]; then      
            SUBSCRIBE_TOPICS="D$DEVICE_INFO_PIN,T$DEVICE_INFO_PIN"
          else
            SUBSCRIBE_TOPICS="$SUBSCRIBE_TOPICS,D$DEVICE_INFO_PIN,T$DEVICE_INFO_PIN"
          fi
        else
          echo "Skipping device. Port in device info '$DEVICE_INFO_PORT' doesn't match target device port '$DEVICE_PORT'"
        fi
    done
else
    echo "No device info found in $DEVICES_DIR"
fi

          
echo "Device names: $DEVICE_NAMES"
echo "Subscribe topics: $SUBSCRIBE_TOPICS"


sed -i "s/switch1/$DEVICE_NAMES/g" $SERVICE_FILE_PATH && \
sed -i "s/D13,T13/$SUBSCRIBE_TOPICS/g" $SERVICE_FILE_PATH && \
sed -i "s/ttyUSB[0-9]/$DEVICE_PORT/g" $SERVICE_FILE_PATH && \

echo "Installing service..."
sh install-service.sh $SERVICE_FILE_PATH && \

echo "Finished creating MQTT bridge service"
