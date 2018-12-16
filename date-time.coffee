command: "date +\"%a %d %b %Y %H:%M%:%S\""

refreshFrequency: 1000

render: ( ) ->
  """
<div class="widg" id="datetime">
  <span class="output nohidden" id="datetime-output"></span>
</div>
  """

update: ( output, domEl ) ->
  el = $(domEl).find("#datetime-output")
  currentValue = el.text()
  updatedValue = output

  if updatedValue != currentValue
    el.text(updatedValue)

