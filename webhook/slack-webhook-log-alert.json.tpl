{
  "channel": "${channel}",
  "text": "@{triggerBody()?['data']?['essentials']?['alertRule']}: @{triggerBody()?['data']?['essentials']?['monitorCondition']}",
  "blocks": [],
  "attachments": [
    {
      "blocks": [
        {
          "text": {
            "text": "<!here>",
            "type": "mrkdwn"
          },
          "type": "section"
        },
        {
          "text": {
            "text": "@{triggerBody()?['data']?['essentials']?['alertRule']}",
            "type": "plain_text"
          },
          "type": "header"
        },
        {
          "text": {
            "text": "_@{triggerBody()?['data']?['essentials']?['description']}_",
            "type": "mrkdwn"
          },
          "type": "section"
        },
        {
          "text": {
            "text": "<@{variables('alarmContext')['dimensions'][4]['value']}|@{variables('alarmContext')['dimensions'][2]['value']}> \n@{variables('alarmContext')['dimensions'][2]['value']} ",
            "type": "mrkdwn"
          },
          "type": "section"
        },
        {
          "text": {
            "text": "*Name:* @{variables('alarmContext')['dimensions'][0]['value']} ",
            "type": "mrkdwn"
          },
          "type": "section"
        },
        {
          "text": {
            "text": "*Request URI:* @{variables('alarmContext')['dimensions'][1]['value']} ",
            "type": "mrkdwn"
          },
          "type": "section"
        },
        {
          "text": {
            "text": "*Details:* @{variables('alarmContext')['dimensions'][3]['value']} ",
            "type": "mrkdwn"
          },
          "type": "section"
        }
      ],
      "color": "#D22B2B"
    }
  ]
}
