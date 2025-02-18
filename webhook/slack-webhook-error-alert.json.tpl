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
              "text": "*Log level:* \n @{variables('alarmContext')['condition']['allOf'][0]['dimensions'][2]['value']}",
              "type": "mrkdwn"
            }
          ],
          "type": "section"
        },
        {
          "text": {
            "text": "*Message:* \n@{variables('alarmContext')['condition']['allOf'][0]['dimensions'][0]['value']}",
            "type": "mrkdwn"
          },
          "type": "section"
        },
        {
          "text": {
            "text": "*Operation name:* \n@{variables('alarmContext')['condition']['allOf'][0]['dimensions'][1]['value']} \n <@{variables('alarmContext')['condition']['allOf'][0]['linkToFilteredSearchResultsUI']}|Go to Log Analytics and run query>",
            "type": "mrkdwn"
          },
          "type": "section"
        }
      ],
      "color": "#4c2c92"
    }
  ]
}
