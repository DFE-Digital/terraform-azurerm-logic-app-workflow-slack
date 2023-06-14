{
  "description": "Conditionally run a subsequent action based on the Resource Group name",
  "cases": {
    %{ for resource_group_name, case in cases ~}
      "${resource_group_name}": {
        "actions": {
          "${resource_group_name}": {
            "inputs": {
              "body" : ${case.body},
              "headers": {
                "Content-Type": "application/json"
              },
              "method": "POST",
              "uri": "${case.uri}"
            },
            "runAfter": {},
            "type": "Http"
          }
        },
        "case": "${resource_group_name}"
      },
    %{ endfor ~}
    "TestCase": {
      "actions": {
        "TestSuccess": {
          "inputs": {
            "runStatus": "Succeeded"
          },
          "runAfter": {},
          "type": "Terminate"
        }
      },
      "case": "test-RG"
    }
  },
  "default": {
    "actions": {
      "DefaultTerminate": {
        "inputs": {
          "runStatus": "Cancelled"
        },
        "runAfter": {},
        "type": "Terminate"
      }
    }
  },
  "expression": "${var_name}",
  "runAfter": {
    "${run_after}": [
      "Succeeded"
    ]
  },
  "type": "Switch"
}
