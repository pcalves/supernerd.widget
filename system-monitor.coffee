commands =
  cpu : "ps -A -o %cpu | awk '{s+=$1} END {printf(\"%.2f\",s/8);}'"
  mem : "ESC=`printf \"\e\"`; ps -A -o %mem | awk '{s+=$1} END {print \"\" s}'"
  hdd : "df / | awk 'END{print $5}'"
  net : "sh ./supernerd.widget/scripts/getnetwork.sh"



command: "echo " +
         "$(#{ commands.cpu }):::" +
         "$(#{ commands.mem }):::" +
         "$(#{ commands.hdd }):::" +
         "$(#{ commands.net }):::"

refreshFrequency: '5s'

render: ( ) ->
  """
<div class="tray" id="time-tray">

  <div class="widg" id="upl">
    down
    <span class="output" id="upl-output"></span>
  </div>

  <div class="widg" id="dwl">
    up
    <span class="output" id="dwl-output"></span>
  </div>

  <div class="widg" id="cpu">
    cpu
    <span class="output" id="cpu-output"></span>
  </div>

  <div class="widg" id="mem">
    mem
    <span class="output" id="mem-output"></span>
  </div>

  <div class="widg" id="hdd">
    hdd
    <span class="output" id="hdd-output"></span>
  </div>
</div>

  """

convertBytes: (bytes) ->
  kb = bytes / 1024
  mb = kb / 1024
  if mb < 0.01
    return "0.00"
  return "#{parseFloat(mb.toFixed(2))}"

update: ( output, domEl ) ->
  output = output.split( /:::/g )

  cpu = output[ 0 ]
  mem = output[ 1 ]
  hdd = output[ 2 ]
  net = output[ 3 ].split( /@/g )
  upl = net[ 0 ]
  dwl = net[ 1 ]


  $( "#cpu-output").text("#{ cpu }")
  $( "#mem-output").text("#{ mem }")
  $( "#hdd-output").text("#{ hdd }")
  $( "#upl-output").text("#{ @convertBytes(upl) }")
  $( "#dwl-output").text("#{ @convertBytes(dwl) }")
