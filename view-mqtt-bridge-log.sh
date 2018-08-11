DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Error: Please provode a device name as parameter"
else
  DEVICE_PORT=$(cat "devices/$DEVICE_NAME/port.txt")

  LOG_FILE="log.txt"
  LOG_FILE="$DEVICE_PORT$LOG_FILE"
  LOG_FILE="scripts/apps/BridgeArduinoSerialToMqttSplitCsv/svc/$LOG_FILE"
  echo "Viewing log file:"
  echo $LOG_FILE

  tail -f $LOG_FILE
fi
