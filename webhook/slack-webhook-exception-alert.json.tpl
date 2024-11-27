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
              "text": "*Resource:* \n <@{concat('https://portal.azure.com/#@', variables('tenantID'))}/resource@{triggerBody()?['data']?['essentials']?['alertTargetIDs']?[0]}|@{last(variables('affectedResource'))}>",
              "type": "mrkdwn"
            },
            {
              "text": "*Severity:* \n @{variables('alarmSeverity')}",
              "type": "mrkdwn"
            }
          ],
          "type": "section"
        },
        {
          "text": {
            "text": "*Exception:* <@{variables('alarmContext')['condition']['allOf'][0]['dimensions'][0]['value']}|@{variables('alarmContext')['condition']['allOf'][0]['dimensions'][3]['value']}> \n@{variables('alarmContext')['condition']['allOf'][0]['dimensions'][2]['value']} ",
            "type": "mrkdwn"
          },
          "type": "section"
        },
        {
          "text": {
            "text": "*Request:* @{variables('alarmContext')['condition']['allOf'][0]['dimensions'][4]['value']} \n@{variables('alarmContext')['condition']['allOf'][0]['dimensions'][1]['value']}",
            "type": "mrkdwn"
          },
          "type": "section"
        }
      ],
      "color": "#1d70b8"
    }
  ]
}
