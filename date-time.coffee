commands =
  datetime  : "date +\"%a %d %b %Y %H:%M%:%S\""

command: "echo $(#{ commands.datetime }):::"

refreshFrequency: 1000

render: ( ) ->
  """
<div class="widg" id="datetime">
  <span class="output nohidden" id="datetime-output"></span>
</div>
  """

update: ( output, domEl ) ->
  output = output.split( /:::/g )

  values = []

  values.datetime = output[ 0 ]

  controls = ['datetime']
  for control in controls
    outputId = "#"+control+"-output"
    currentValue = $("#{outputId}").value
    updatedValue = values[control]

    if updatedValue != currentValue
      $("#{ outputId }").text("#{ updatedValue }")

