{
  "description": "Alarm context",
  "inputs": {
    "variables": [{
      "name": "alarmContext",
      "type": "object",
      "value": "@triggerBody()?['data']?['alertContext']"
    }]
  },
  "runAfter": {},
  "type": "InitializeVariable"
}
