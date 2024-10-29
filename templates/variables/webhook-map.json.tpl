{
  "description": "Resource Group to Webhook map",
  "inputs": {
    "variables": [{
      "name": "webhookMap",
      "type": "object",
      "value": ${map}
    }]
  },
  "runAfter": {},
  "type": "InitializeVariable"
}
