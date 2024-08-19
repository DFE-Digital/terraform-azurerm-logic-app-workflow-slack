{
  "description": "Signal Type",
  "inputs": {
    "variables": [{
      "name": "signalType",
      "type": "string",
      "value": "@triggerBody()?['data']?['essentials']?['signalType']"
    }]
  },
  "runAfter": {
    "${run_after}": [
      "Succeeded"
    ]
  },
  "type": "InitializeVariable"
}
