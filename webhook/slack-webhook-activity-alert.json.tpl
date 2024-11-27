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
              "text": "*Resource:* \n <@{concat('https://portal.azure.com/#@', variables('tenantID'))}/resource@{triggerBody()?['data']?['essentials']?['alertTargetIDs']?[0]}|@{triggerBody()?['data']?['essentials']?['configurationItems']?[0]}>",
              "type": "mrkdwn"
            },
            {
              "text": "*Type:* \n @{triggerBody()?['data']?['essentials']?['targetResourceType']}",
              "type": "mrkdwn"
            }
          ],
          "type": "section"
        },
        {
          "text": {
            "text": "*Caller:* @{variables('alarmContext')['caller']}",
            "type": "mrkdwn"
          },
          "type": "section"
        },
        {
          "text": {
            "text": "*Operation:* \n@{variables('alarmContext')['operationName']} (@{variables('alarmContext')['status']})",
            "type": "mrkdwn"
          },
          "type": "section"
        }
      ],
      "color": "#003764"
    }
  ]
}
