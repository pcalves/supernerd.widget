commands =
  volume : "osascript -e 'get volume settings' | cut -f2 -d':' | cut -f1 -d',';"
  battery : "pmset -g batt | egrep '([0-9]+\%).*' -o --colour=auto | cut -f1 -d';'"
  ismuted : "osascript -e 'output muted of (get volume settings)'"


command: "echo " +
         "$(#{ commands.volume }):::" +
         "$(#{ commands.battery }):::" +
         "$(#{ commands.ismuted }):::"

refreshFrequency: '1s'

render: ( ) ->
  """
<div class="container">
  <div class="tray" id="tray">
    <div class="widg toggleable" id="volume">
      vol
      <span class="output nohidden" id='volume-output' />
    </div>

    <div class="widg toggleable" id="battery">
      bat
      <span class="output nohidden" id='battery-output' />
    </div>
  </div>
</div>

  """

update: ( output, domEl ) ->
  output = output.split( /:::/g )

  values = []
  values.volume  = output[0]
  values.battery = output[1]

  if (output[2] == 'true')
    values.volume = 0


  controls = ['volume', 'battery']
  for control in controls
    outputId = "#"+control+"-output"
    currentValue = $("#{outputId}").value
    updatedValue = values[control]

    if updatedValue != currentValue
      $("#{ outputId }").text("#{ updatedValue }")
