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
          "text": {
            "text": "*<@{variables('alarmContext')['condition']['allOf'][0]['dimensions'][0]['value']}|@{variables('alarmContext')['condition']['allOf'][0]['dimensions'][3]['value']}>* \n @{variables('alarmContext')['condition']['allOf'][0]['dimensions'][1]['value']}",
            "type": "mrkdwn"
          },
          "type": "section"
        },
        {
          "text": {
            "type": "mrkdwn",
            "text": "*Request:* @{variables('alarmContext')['condition']['allOf'][0]['dimensions'][6]['value']}"
          },
          "type": "section"
        },
        {
          "type": "context",
          "elements": [
            {
              "text": "*Operation ID:* @{variables('alarmContext')['condition']['allOf'][0]['dimensions'][2]['value']}",
              "type": "mrkdwn"
            },
            {
              "text": "*Status code:* @{variables('alarmContext')['condition']['allOf'][0]['dimensions'][4]['value']}",
              "type": "mrkdwn"
            },
            {
              "text": "*Log level:* @{variables('alarmContext')['condition']['allOf'][0]['dimensions'][5]['value']}",
              "type": "mrkdwn"
            }
          ]
        }
      ],
      "color": "@{if(equals(variables('alarmContext')['condition']['allOf'][0]['dimensions'][5]['value'], 'Error'), '#d4351c', '#f47738')}"
    }
  ]
}
