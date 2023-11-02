{
  "channel": "${channel}",
  "text": ":warning: A HTTP request was `@{variables('alarmContext')['dimensions'][0]['value']}` by security rule `@{variables('alarmContext')['dimensions'][6]['value']}`.",
  "blocks": [],
  "attachments": [
    {
      "blocks": [
        {
          "text": {
            "text": "*Reason:* @{variables('alarmContext')['dimensions'][4]['value']} ",
            "type": "mrkdwn"
          },
          "type": "section"
        },
        {
          "text": {
            "text": "*Hostname:* @{variables('alarmContext')['dimensions'][3]['value']} ",
            "type": "mrkdwn"
          },
          "type": "section"
        },
        {
          "text": {
            "text": "*Request URI:* @{variables('alarmContext')['dimensions'][5]['value']} ",
            "type": "mrkdwn"
          },
          "type": "section"
        },
        {
          "text": {
            "text": "*Details:* @{variables('alarmContext')['dimensions'][1]['value']} ",
            "type": "mrkdwn"
          },
          "type": "section"
        }
      ],
      "color": "#eed202"
    }
  ]
}
