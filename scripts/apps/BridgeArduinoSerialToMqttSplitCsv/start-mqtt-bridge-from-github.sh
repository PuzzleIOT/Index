
INIT_SCRIPT_FILE_URL="https://raw.githubusercontent.com/PuzzleIOT/Index/master/scripts/apps/BridgeArduinoSerialToMqttSplitCsv/init.sh"
wget -O - $INIT_SCRIPT_FILE_URL | sh -s || exit 1

mono BridgeArduinoSerialToMqttSplitCsv/lib/net40/BridgeArduinoSerialToMqttSplitCsv.exe $1 $2 $3 $4 $5
