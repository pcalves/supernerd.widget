options =
  focus: false
  desktop: true


commands =
  activedesk: "echo $(/usr/local/bin/chunkc tiling::query -d id)"
  playing: "echo $(sh ./supernerd.widget/scripts/gettrack.sh)"
  progress: "echo $(sh ./supernerd.widget/scripts/gettrackprogress.sh)"
  isplaying: "echo $(sh ./supernerd.widget/scripts/ismpcplaying.sh)"

command: "echo " +
         "$(#{ commands.activedesk }):::" +
         "$(#{ commands.playing}):::" +
         "$(#{ commands.progress}):::" +
         "$(#{ commands.isplaying}):::"

refreshFrequency: '1s'

render: ( ) ->
  """
<div class="container">
<div class="widg tray-button pinned red" id="home">
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
  progress = output[2]
  isplaying = output[3]

  if isplaying == "true"
    @handlePlayIcon(domEl, true)
  else
    @handlePlayIcon(domEl, false)


  playingOutput = playing

  if progress
    playingOutput += ' (' + progress + ')'

  $(domEl).find('#play-output').text(playingOutput)

  if options.desktop is true
    if $("#active-desktop").text != activedesk
      $("#active-desktop").text(activedesk)


#
# ─── HANDLES  ─────────────────────────────────────────────────────────
#

getDesktopColor: (activedesk) ->
  color = switch
    when activedesk == "1" then "red"
    when activedesk == "2" then "yellow"
    when activedesk == "3" then "blue"
    when activedesk == "4" then "magenta"

  return color

handlePlayIcon: (domEl, status) ->
  if status == 'NULL'
      status = true
    else
      status = false

  if status == true
    $(domEl).find('#play-list').removeClass("hidden")
  else
    $(domEl).find('#play-list').addClass("hidden")
