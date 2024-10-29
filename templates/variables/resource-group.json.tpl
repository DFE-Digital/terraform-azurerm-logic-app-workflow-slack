{
  "description": "Resource Group",
  "inputs": {
    "variables": [{
      "name": "resourceGroup",
      "type": "string",
      "value": "@split(triggerBody()?['data']?['essentials']?['alertTargetIDs'][0], '/')[4]"
    }]
  },
  "runAfter": {},
  "type": "InitializeVariable"
}
