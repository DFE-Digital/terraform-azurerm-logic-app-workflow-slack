{
  "description": "${description}",
  "cases": {
    %{ if length(cases) > 0 ~}
      %{ for key, case in cases ~}
        "${key}.case": {
          "actions": {
            "${key}.action": ${case.action}
          },
          "case": "${key}"
        },
      %{ endfor ~}
    %{ endif ~}
    "${name}.TestCase": {
      "actions": {
        "${name}.Action.TestSuccess": {
          "inputs": {
            "runStatus": "Succeeded"
          },
          "runAfter": {},
          "type": "Terminate"
        }
      },
      "case": "test"
    }
  },
  "default": {
    "actions": {
      %{ if default_action != "[]" }
        "DefaultAction": ${default_action}
      %{ else }
      "DefaultTerminate": {
        "inputs": {
          "runStatus": "Cancelled"
        },
        "runAfter": {},
        "type": "Terminate"
      }
      %{ endif ~}
    }
  },
  "runAfter": ${run_after},
  "expression": "${expression}",
  "type": "Switch"
}
