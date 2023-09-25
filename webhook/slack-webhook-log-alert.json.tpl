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
            "text": "*Alarm status:* @{triggerBody()?['data']?['essentials']?['monitorCondition']}",
            "type": "mrkdwn"
          },
          "type": "section"
        },
        {
          "type": "section",
          "text": {
            "text": "*Exception* - <@{variables('alarmContext')['linkToSearchResultsUI']}|View in Log Analytics>\n @{variables('alarmContext')['dimensions'][3]['value']} ",
            "type": "mrkdwn"
          }
        },
        {
          "text": {
            "text": "```@{variables('alarmContext')['dimensions'][2]['value']}``` ",
            "type": "mrkdwn"
          },
          "type": "section"
        },
        {
          "fields": [
            {
              "text": "*Resource Group*",
              "type": "mrkdwn"
            },
            {
              "text": "@{variables('affectedResource')[4]} ",
              "type": "plain_text"
            },
            {
              "text": "*Severity*",
              "type": "mrkdwn"
            },
            {
              "text": "@{triggerBody()?['data']?['essentials']?['severity']} ",
              "type": "plain_text"
            },
            {
              "text": "*Count*",
              "type": "mrkdwn"
            },
            {
              "text": "@{variables('alarmContext')['dimensions'][1]['value']} ",
              "type": "plain_text"
            },
            {
              "text": "*Type*",
              "type": "mrkdwn"
            },
            {
              "text": "@{variables('alarmContext')['dimensions'][4]['value']} ",
              "type": "plain_text"
            }
          ],
          "type": "section"
        }
      ],
      "color": "@{if(equals(triggerBody()?['data']?['essentials']?['monitorCondition'], 'Resolved'), '#50C878', '#D22B2B')}"
    }
  ]
}
