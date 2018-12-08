commands =
  activedesk: "echo $(/usr/local/bin/chunkc tiling::query -d id)"
  playing: "echo $(sh ./supernerd.widget/scripts/gettrack.sh)"
  isplaying: "echo $(sh ./supernerd.widget/scripts/ismpcplaying.sh)"

command: "echo " +
         "$(#{ commands.activedesk }):::" +
         "$(#{ commands.playing}):::" +
         "$(#{ commands.isplaying}):::"

refreshFrequency: '2s'

render: ( ) ->
  """
<div class="container">
<div class="widg tray-button pinned" id="home">
  <div class="icon-container" id="home-icon-container">
  <span id="active-desktop"></span>
  </div>
</div>

<div class="tray" id="play-tray">
  <div class="widg" id="playing">
    <span class="output nohidden" id='play-output'></span>
  </div>
</div>
</div>
  """

update: ( output, domEl ) ->
  output = output.split( /:::/g )
  activedesk = output[0]
  playing = output[1]
  isplaying = output[2]

  $(domEl).find('#play-output').text(playing)

  if $("#active-desktop").text != activedesk
    $("#active-desktop").text(activedesk)
