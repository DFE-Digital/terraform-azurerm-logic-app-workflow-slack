{
  "description": "Conditionally run a subsequent action based on an expression",
  "cases": {
    %{ if length(cases) > 0 ~}
      %{ for key, case in cases ~}
        "${key}-case": {
          "actions": {
            "${key}-action": ${case.action}
          },
          "case": "${key}"
        },
      %{ endfor ~}
    %{ endif ~}
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
  "runAfter": ${run_after},
  "expression": "${expression}",
  "type": "Switch"
}
