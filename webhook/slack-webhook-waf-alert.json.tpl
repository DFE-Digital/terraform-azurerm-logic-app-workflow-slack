{
  "channel": "${channel}",
  "text": ":warning: @{triggerBody()?['data']?['essentials']?['description']}",
  "blocks": [],
  "attachments": [
    {
      "blocks": [
        {
          "text": {
            "text": "*Hostname:* @{variables('alarmContext')['dimensions'][1]['value']} ",
            "type": "mrkdwn"
          },
          "type": "section"
        },
        {
          "text": {
            "text": "A HTTP request was `@{variables('alarmContext')['dimensions'][0]['value']}` by ruleset `@{variables('alarmContext')['dimensions'][2]['value']}`. \n<@{variables('alarmContext')['linkToFilteredSearchResultsUI']}|Go to Log Analytics and run query> ",
            "type": "mrkdwn"
          },
          "type": "section"
        }
      ],
      "color": "#eed202"
    }
  ]
}
