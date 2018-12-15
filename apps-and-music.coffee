desktopMap = {
  '1': '一',
  '2': '二',
  '3': '三',
  '4': '四',
  '5': '五',
  '6': '六',
  '7': '七',
  '8': '八',
  '9': '九',
  '10': '十'
}

commands =
  desktops: "echo $(/usr/local/bin/chunkc tiling:query -D 1)"
  activedesk: "echo $(/usr/local/bin/chunkc tiling::query -d id)"
  playing: "echo $(sh ./supernerd.widget/scripts/gettrack.sh)"
  isplaying: "echo $(sh ./supernerd.widget/scripts/ismpcplaying.sh)"
  ispaused: "echo $(sh ./supernerd.widget/scripts/ismpcpaused.sh)"
  progress: "echo $(sh ./supernerd.widget/scripts/gettrackprogress.sh)"

command: "echo " +
         "$(#{ commands.desktops }):::" +
         "$(#{ commands.activedesk }):::" +
         "$(#{ commands.playing }):::" +
         "$(#{ commands.isplaying }):::" +
         "$(#{ commands.ispaused }):::" +
         "$(#{ commands.progress }):::"

refreshFrequency: '100ms'

render: ( ) ->
  """
<div class="container">
<div class="widg tray-button pinned" id="home">
  <div class="icon-container" id="home-icon-container">
    <span class="icon" id="active-desktop">1</span>
    <span class="icon" id="active-desktop">2</span>
    <span class="icon" id="active-desktop">3</span>
    <span class="icon" id="active-desktop">4</span>
    <span class="icon" id="active-desktop">5</span>
    <span class="icon" id="active-desktop">6</span>
  </div>
</div>

<div class="tray" id="play-tray">
  <div class="widg" id="playing">
    <span class="output nohidden mr0" id='play-output'></span>
    <span class="output nohidden" id='play-progress'></span>
  </div>
</div>
</div>
  """

update: ( output, domEl ) ->
  output = output.split( /:::/g )
  desktops = output[0].split(' ')
  activedesk = output[1]
  playing = output[2]
  isplaying = output[3] == 'true'
  ispaused = output[4] == 'true'
  progress = output[5]

  playingInfo = playing.split(' - ')
  playOutput = $(domEl).find("#play-output")
  playProgress = $(domEl).find("#play-progress")
  desktopContainer = $(domEl).find("#home-icon-container")
  desktopIcons = $(domEl).find(".icon")
  separator = '<span class="separator">•</span>';

  playOutput.empty()
  playProgress.empty()

  if isplaying || ispaused
    playOutput.append(
      playingInfo[0] +
      separator +
      playingInfo[1]
    );
    playProgress.append(separator + progress)

  if (ispaused)
    playProgress.append(' (paused)')

  if (desktopContainer.children().length != desktops.length)
    desktopContainer.empty()
    for index, num of desktops
      desktopContainer.append("<span class='icon'>" + desktopMap[num] + "</span");

  desktopIcons.removeClass('active')
  desktopIcons.eq(activedesk - 1).addClass('active');
