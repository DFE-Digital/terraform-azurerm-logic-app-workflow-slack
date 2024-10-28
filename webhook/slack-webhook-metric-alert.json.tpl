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
            "text": "*Alert Rule:* @{triggerBody()?['data']?['essentials']?['alertRule']} \n*Description:* _@{triggerBody()?['data']?['essentials']?['description']}_ ",
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
              "text": "*Severity:* \n @{variables('alarmSeverity')}",
              "type": "mrkdwn"
            }
          ],
          "type": "section"
        },
        {
          "text": {
            "text": "*Metric:* @{variables('alarmContext')['metricName']} @{variables('alarmContext')['timeAggregation']} @{variables('alarmContext')['operator']} @{variables('alarmContext')['threshold']}",
            "type": "mrkdwn"
          },
          "type": "section"
        },
        {
          "text": {
            "text": "*Recorded value:* \n@{variables('alarmContext')['metricValue']} ",
            "type": "mrkdwn"
          },
          "type": "section"
        }
      ],
      "color": "@{if(equals(triggerBody()?['data']?['essentials']?['monitorCondition'], 'Resolved'), '#00703c', '#d4351c')}"
    }
  ]
}
