mkdir -p parts && \

# Unzip the linear MQTT config file

rm -f settings.json && \
unzip config.linear && \

# Extract the template parts

sh extract-parts.sh

# Create the blank template file

cp settings.json template.json && \

JSON_VALUE=$(jq 'del(.dashboards[0].dashboard[1])' template.json) && \
echo $JSON_VALUE > template.json && \

JSON_VALUE=$(jq 'del(.dashboards[0].dashboard[0])' template.json) && \
echo $JSON_VALUE > template.json && \

JSON_VALUE=$(jq 'del(.tabs[2])' template.json) && \
echo $JSON_VALUE > template.json && \

JSON_VALUE=$(jq 'del(.tabs[1])' template.json) && \
echo $JSON_VALUE > template.json && \

JSON_VALUE=$(jq 'del(.dashboards[2])' template.json) && \
echo $JSON_VALUE > template.json && \

JSON_VALUE=$(jq 'del(.dashboards[1])' template.json) && \
echo $JSON_VALUE > template.json && \

# Copy the template file to the new settings file as a starting point
cp template.json newsettings.json && \

echo "Extraction complete"
