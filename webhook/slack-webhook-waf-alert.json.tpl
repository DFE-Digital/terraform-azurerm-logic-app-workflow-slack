{
  "channel": "${channel}",
  "text": ":warning: @{triggerBody()?['data']?['essentials']?['description']}",
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
            "text": "*Hostname:* @{variables('alarmContext')['condition']['allOf'][0]['dimensions'][1]['value']} ",
            "type": "mrkdwn"
          },
          "type": "section"
        },
        {
          "text": {
            "text": "A HTTP request was `@{variables('alarmContext')['condition']['allOf'][0]['dimensions'][0]['value']}` by ruleset `@{variables('alarmContext')['condition']['allOf'][0]['dimensions'][2]['value']}`. \n<@{variables('alarmContext')['condition']['allOf'][0]['linkToFilteredSearchResultsUI']}|Go to Log Analytics and run query> ",
            "type": "mrkdwn"
          },
          "type": "section"
        }
      ],
      "color": "#eed202"
    }
  ]
}
