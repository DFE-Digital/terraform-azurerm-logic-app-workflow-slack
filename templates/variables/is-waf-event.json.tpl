{
  "description": "WAF Condition",
  "inputs": {
    "variables": [{
      "name": "isWAF",
      "type": "Boolean",
      "value": "@if(contains(split(triggerBody()?['data']?['essentials']?['alertTargetIDs'][0], '/')[4], 'waf'), true, false)"
    }]
  },
  "runAfter": {},
  "type": "InitializeVariable"
}
