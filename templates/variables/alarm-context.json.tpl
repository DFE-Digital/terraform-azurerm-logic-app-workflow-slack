{
  "description": "Alarm context",
  "inputs": {
    "variables": [{
      "name": "alarmContext",
      "type": "object",
      "value": "@triggerBody()?['data']?['alertContext']['condition']['allOf'][0]"
    }]
  },
  "runAfter": {},
  "type": "InitializeVariable"
}
