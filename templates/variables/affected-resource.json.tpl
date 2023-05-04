{
  "description": "Affected resource",
  "inputs": {
    "variables": [{
      "name": "affectedResource",
      "type": "array",
      "value": "@split(triggerBody()?['data']?['essentials']?['alertTargetIDs'][0], '/')"
    }]
  },
  "runAfter": {},
  "type": "InitializeVariable"
}
