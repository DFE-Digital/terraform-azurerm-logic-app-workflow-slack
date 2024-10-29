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
            "text": "*Metric:* \n@{variables('alarmContext')['metricMeasureColumn']} @{variables('alarmContext')['timeAggregation']} @{variables('alarmContext')['operator']} @{variables('alarmContext')['threshold']}",
            "type": "mrkdwn"
          },
          "type": "section"
        },
        {
          "text": {
            "text": "*Recorded value:* \n@{variables('alarmContext')['metricValue']} \n <@{variables('alarmContext')['linkToFilteredSearchResultsUI']}|Go to Log Analytics and run query>",
            "type": "mrkdwn"
          },
          "type": "section"
        }
      ],
      "color": "#f47738"
    }
  ]
}
