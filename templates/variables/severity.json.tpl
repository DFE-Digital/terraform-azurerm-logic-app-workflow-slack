{
  "description": "Alarm Severity",
  "inputs": {
    "variables": [{
      "name": "alarmSeverity",
      "type": "string",
      "value": "@triggerBody()?['data']?['essentials']?['severity']"
    }]
  },
  "runAfter": {},
  "type": "InitializeVariable"
}
