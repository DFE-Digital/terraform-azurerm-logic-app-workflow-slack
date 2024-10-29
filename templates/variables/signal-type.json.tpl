{
  "description": "Signal Type",
  "inputs": {
    "variables": [{
      "name": "signalType",
      "type": "string",
      "value": "@triggerBody()?['data']?['essentials']?['signalType']"
    }]
  },
  "runAfter": {},
  "type": "InitializeVariable"
}
