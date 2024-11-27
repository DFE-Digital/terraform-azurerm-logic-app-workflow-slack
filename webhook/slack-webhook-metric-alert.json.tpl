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
              "text": "*Severity:* \n @{variables('alarmSeverity')}",
              "type": "mrkdwn"
            }
          ],
          "type": "section"
        },
        {
          "text": {
            "text": "*Metric:* @{variables('alarmContext')['condition']['allOf'][0]['metricName']} @{variables('alarmContext')['condition']['allOf'][0]['timeAggregation']} @{variables('alarmContext')['condition']['allOf'][0]['operator']} @{variables('alarmContext')['condition']['allOf'][0]['threshold']}",
            "type": "mrkdwn"
          },
          "type": "section"
        },
        {
          "text": {
            "text": "*Recorded value:* \n@{variables('alarmContext')['condition']['allOf'][0]['metricValue']} ",
            "type": "mrkdwn"
          },
          "type": "section"
        }
      ],
      "color": "@{if(equals(triggerBody()?['data']?['essentials']?['monitorCondition'], 'Resolved'), '#00703c', '#d4351c')}"
    }
  ]
}
