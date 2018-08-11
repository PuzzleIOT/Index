echo ""
echo "Creating garden switch configuration"
echo ""

# Example:
# sh create-switch-ui.sh [Label] [DeviceName]
# sh create-switch-ui.sh MySwitch myswitch

DIR=$PWD
DEVICE_EXISTS=false

DEVICE_LABEL=$1
DEVICE_NAME=$2
DEVICE_PIN=$3

if [ ! $DEVICE_LABEL ]; then
  DEVICE_LABEL="Switch1"
fi

if [ ! $DEVICE_NAME ]; then
  DEVICE_NAME="switch1"
fi

if [ ! $DEVICE_PIN ]; then
  DEVICE_PIN="13"
fi

DEVICE_INFO_DIR="devices/$DEVICE_NAME"
if [ -d "$DEVICE_INFO_DIR" ]; then
  DEVICE_EXISTS=true
fi


if [ $DEVICE_EXISTS = false ]; then
  cd "mobile/linearmqtt/"

  sh increment-device-count.sh

  echo "Device label: $DEVICE_LABEL"
  echo "Device name: $DEVICE_NAME"
  echo "Device pin: $DEVICE_PIN"

  DEVICE_COUNT=$(cat devicecount.txt) && \
  DEVICE_ID=$(($DEVICE_COUNT+1)) && \

  echo "Device number: $DEVICE_COUNT" && \

  # Switch summary

  SWITCH_ELEMENT=$(cat parts/switchelement.json) && \

  SWITCH_ELEMENT=$(echo $SWITCH_ELEMENT | sed "s/Switch1/$DEVICE_LABEL/g") && \
  SWITCH_ELEMENT=$(echo $SWITCH_ELEMENT | sed "s/switch1/$DEVICE_NAME/g") && \
  SWITCH_ELEMENT=$(echo $SWITCH_ELEMENT | sed "s/D13/D$DEVICE_PIN/g") && \

  #SWITCH_ELEMENT=$(echo $SWITCH_ELEMENT | jq .id=$DEVICE_ID) && \

  NEW_SETTINGS=$(jq ".dashboards[0].dashboard[$(($DEVICE_COUNT-1))] |= . + $SWITCH_ELEMENT" newsettings.json) && \

  echo $NEW_SETTINGS > newsettings.json && \

  sh package.sh
else
  echo "Device already exists. Skipping UI creation."
fi


cd $DIR && \

echo "Finished creating switch UI"
