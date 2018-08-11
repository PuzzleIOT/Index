mkdir -p parts

# Unzip the linear MQTT config file

rm -f settings.config
unzip config.linear

# Extract the template parts

SWITCHES_DASHBOARD=$(jq -r '.dashboards[0]' settings.json)
echo $SWITCHES_DASHBOARD > parts/switchesdashboard.json

SWITCH_ELEMENT=$(jq -r '.dashboards[0].dashboard[0]' settings.json)
echo $SWITCH_ELEMENT > parts/switchelement.json

cp settings.json template.json

#JSON_VALUE=$(jq -r 'del(.dashboards[0].dashboard[0])' template.json)
#echo $JSON_VALUE > template.json

echo "Extraction complete"
