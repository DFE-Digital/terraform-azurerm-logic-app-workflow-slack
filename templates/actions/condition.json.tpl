{
  "description": "Compare two values in an expression and execute an action based on the result",
  "actions": {
    %{ if action_if_true != "{}" ~} "${name}-action-true" : ${action_if_true} %{ endif ~}
  },
  "else": {
    "actions": {
      %{ if action_if_false != "{}" ~} "${name}-action-false" : ${action_if_false} %{ endif ~}
    }
  },
  "runAfter": ${run_after},
  "expression": {
    "and": [
      {
        "${condition}": [
          "${haystack}",
          "${needle}"
        ]
      }
    ]
  },
  "type": "If"
}
