{
  "channel": "${channel}",
  "text": "@{triggerBody()?['data']?['essentials']?['alertRule']}: @{triggerBody()?['data']?['essentials']?['monitorCondition']}",
  "blocks": [],
  "attachments": [
    {
      "blocks": [
        %{ if message_tag != "" }
        {
          "text": {
            "text": "${message_tag}",
            "type": "mrkdwn"
          },
          "type": "section"
        },
        %{ endif }
        {
          "text": {
            "text": "*Alert Rule:* @{triggerBody()?['data']?['essentials']?['alertRule']} \n*Description:* @{triggerBody()?['data']?['essentials']?['description']} ",
            "type": "mrkdwn"
          },
          "type": "section"
        },
        {
          "fields": [
            {
              "text": "*Resource:* \n <@{concat('https://portal.azure.com/#@', variables('tenantID'))}/resource/subscriptions/@{variables('affectedResource')[2]}/resourceGroups/@{variables('resourceGroup')}/providers/Microsoft.App/containerApps/@{variables('alarmContext')['condition']['allOf'][0]['dimensions'][2]['value']}/containerapp|@{variables('alarmContext')['condition']['allOf'][0]['dimensions'][2]['value']}>",
              "type": "mrkdwn"
            },
            {
              "text": "*Log level:* \n @{variables('alarmContext')['condition']['allOf'][0]['dimensions'][4]['value']}",
              "type": "mrkdwn"
            }
          ],
          "type": "section"
        },
        {
          "text": {
            "text": "*@{variables('alarmContext')['condition']['allOf'][0]['dimensions'][0]['value']}* \n @{variables('alarmContext')['condition']['allOf'][0]['dimensions'][3]['value']}",
            "type": "mrkdwn"
          },
          "type": "section"
        },
        {
          "type": "context",
          "elements": [
            {
              "text": "*Operation ID:* @{variables('alarmContext')['condition']['allOf'][0]['dimensions'][1]['value']}",
              "type": "mrkdwn"
            }
          ]
        }
      ],
      "color": "#4c2c92"
    }
  ]
}
