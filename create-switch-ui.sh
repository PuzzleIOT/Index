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

if [ ! $DEVICE_LABEL ]; then
  DEVICE_LABEL="Switch1"
fi
if [ ! $DEVICE_NAME ]; then
  DEVICE_NAME="switch1"
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

  DEVICE_COUNT=$(cat devicecount.txt) && \
  DEVICE_ID=$(($DEVICE_COUNT+1)) && \

  echo "Device number: $DEVICE_COUNT" && \

  # Switch tab

  IRRIGATOR_TAB=$(cat parts/switchtab.json)

  IRRIGATOR_TAB=$(echo $IRRIGATOR_TAB | sed "s/Switch1/$DEVICE_LABEL/g") && \
  IRRIGATOR_TAB=$(echo $IRRIGATOR_TAB | sed "s/switch1/$DEVICE_NAME/g") && \

  IRRIGATOR_TAB=$(echo $IRRIGATOR_TAB | jq .id=$DEVICE_ID) && \

  NEW_SETTINGS=$(jq ".tabs[$DEVICE_COUNT] |= . + $IRRIGATOR_TAB" newsettings.json) && \

  echo $NEW_SETTINGS > newsettings.json && \

  # Switch summary

  IRRIGATOR_SUMMARY=$(cat parts/switchsummary.json) && \

  IRRIGATOR_SUMMARY=$(echo $IRRIGATOR_SUMMARY | sed "s/Switch1/$DEVICE_LABEL/g") && \
  IRRIGATOR_SUMMARY=$(echo $IRRIGATOR_SUMMARY | sed "s/switch1/$DEVICE_NAME/g") && \

  #IRRIGATOR_SUMMARY=$(echo $IRRIGATOR_SUMMARY | jq .id=$DEVICE_ID) && \

  NEW_SETTINGS=$(jq ".dashboards[0].dashboard[$(($DEVICE_COUNT-1))] |= . + $IRRIGATOR_SUMMARY" newsettings.json) && \

  echo $NEW_SETTINGS > newsettings.json && \


  # Switch dashboard

  IRRIGATOR_DASHBOARD=$(cat parts/switchdashboard.json) && \

  IRRIGATOR_DASHBOARD=$(echo $IRRIGATOR_DASHBOARD | sed "s/Switch1/$DEVICE_LABEL/g") && \
  IRRIGATOR_DASHBOARD=$(echo $IRRIGATOR_DASHBOARD | sed "s/switch1/$DEVICE_NAME/g") && \

  #IRRIGATOR_DASHBOARD=$(echo $IRRIGATOR_DASHBOARD | jq .id=$DEVICE_ID) && \

  NEW_SETTINGS=$(jq ".dashboards[$DEVICE_COUNT] |= . + $IRRIGATOR_DASHBOARD" newsettings.json) && \

  echo $NEW_SETTINGS > newsettings.json && \

  NEW_SETTINGS=$(jq ".dashboards[$DEVICE_COUNT].id=\"$DEVICE_ID\"" newsettings.json) && \

  echo $NEW_SETTINGS > newsettings.json && \

  sh package.sh
else
  echo "Device already exists. Skipping UI creation."
fi


cd $DIR && \

echo "Finished creating switch UI"
