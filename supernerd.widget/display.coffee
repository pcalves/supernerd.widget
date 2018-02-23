#
# ──────────────────────────────────────────────── I ───────
#   :::::: S U P E R N E R D
# ──────────────────────────────────────────────────────────
#
style: """
    @import url(supernerd.widget/styles/default.css);
"""

options =
  styleFilename: 'default'
  refreshFrequency: '10s'

#
# ─── ALL COMMANDS ───────────────────────────────────────────────────────────
#

commands =
  battery: "pmset -g batt | egrep '([0-9]+\%).*' -o --colour=auto " +
           "| cut -f1 -d';'"
  time   : "date +\"%H:%M\""
  wifi   : "/System/Library/PrivateFrameworks/Apple80211.framework/" +
           "Versions/Current/Resources/airport -I | " +
           "sed -e \"s/^ *SSID: //p\" -e d"
  volume : "osascript -e 'output volume of (get volume settings)'"
  cpu : "ps -A -o %cpu | awk '{s+=$1} END {printf(\"%.2f\",s/8);}'"
  mem : "ps -A -o %mem | awk '{s+=$1} END {print s \"%\"}' "
  hdd : "df -hl | awk '{s+=$5} END {print s \"%\"}'"
  date  : "date +\"%a %d %b\""
  focus : "/usr/local/bin/chunkc tiling::query --window name"
  playing: "osascript -e 'tell application \"iTunes\" to if player state is playing then artist of current track & \" - \" & name of current track'"
  ismuted : "osascript -e 'output muted of (get volume settings)'"
  ischarging : "sh ./supernerd.widget/scripts/ischarging.sh"
  activedesk : "echo $(/usr/local/bin/chunkc tiling::query -d id)"

#
# ─── COLORS ─────────────────────────────────────────────────────────────────
#

colors =
  black:   "#101010"
  red:     "#D17D60"
  green:   "#9ABA77"
  yellow:  "#BAB777"
  blue:    "#77ADBA"
  magenta: "#BA77B2"
  cyan:    "#77BAAD"
  white:   "#8f8f8f"

#
# ─── STYLE ─────────────────────────────────────────────────────────────────
#
style: """
    @import url(https://use.fontawesome.com/releases/v5.0.6/css/all.css);
    @import url(supernerd.widget/styles/""" + options.styleFilename + """.css);
"""

#
# ─── COMMAND ────────────────────────────────────────────────────────────────
#

command: "echo " +
         "$(#{ commands.battery }):::" +
         "$(#{ commands.time }):::" +
         "$(#{ commands.wifi }):::" +
         "$(#{ commands.volume }):::" +
         "$(#{ commands.cpu }):::" +
         "$(#{ commands.mem }):::" +
         "$(#{ commands.hdd }):::" +
         "$(#{ commands.date }):::" +
         "$(#{ commands.focus }):::" +
         "$(#{ commands.playing }):::" +
         "$(#{ commands.ismuted }):::" +
         "$(#{ commands.ischarging }):::" +
         "$(#{ commands.activedesk }):::"


#
# ─── REFRESH ────────────────────────────────────────────────────────────────
#

refreshFrequency: options.refreshFrequency

#
# ─── RENDER ─────────────────────────────────────────────────────────────────
#

render: (output) ->
  """
  <div id="main">
    <div class="bar top" id="top">

      <div class="container" id="left">
        <div class="widg" id="supernerd-widget-display-coffee-music">
          <i class="fab fa-itunes-note"></i>
          <span class="playing"></span>
        </div>
      </div>

    <div class="container center" id="center">
      <div class="widg" id="window">

        <span class="window-output"></span>
      </div>
    </div>

    <div class="container right" id="right">
      <div class="widg" id="supernerd-widget-display-coffee-volume">
        <span class="volume-icon"></span>
        <span class="volume-output"></span>
      </div>
      <div class="widg" id="wifi">
        <i class="fa fa-wifi"></i>
        <span class="wifi-output"></span>
      </div>
      <div class="widg battery" id="battery">
        <span class="battery-icon"></span>
        <span class="battery-output"></span>
      </div>
      <div class="widg" id="time">
        <i class="far fa-clock"></i>
        <span class="time-output"></span>
      </div>
      <div class="widg" id="date">
        <i class="far fa-calendar-alt"></i>
        <span class="date-output"></span>
      </div>
    </div>
  </div>

  <div class="bar bottom" id="bottom">

    <div class="container left" id="left">
      <div class="widg" id="home">
        <i class="fas fa-home"></i>
        ~/
      </div>
      <div class="widg" id="browser">
        <i class="far fa-compass"></i>
        web
      </div>
      <div class="widg" id="mail">
        <i class="far fa-envelope"></i>
        mail
      </div>
      <div class="widg" id="messages">
        <i class="far fa-comments"></i>
        msg
      </div>
      <div class="widg" id="terminal">
        <i class="far fa-terminal"></i>
        zsh
      </div>
      <div class="widg" id="editor">
        <i class="far fa-code"></i>
        atom
      </div>
    </div>

    <div class="container center" id="center">
      <div class="widg">
        <i class="fa fa-window-maximize desk" id="desk1"></i>
        <i class="fa fa-window-maximize desk" id="desk2"></i>
        <i class="fa fa-window-maximize desk" id="desk3"></i>
        <i class="fa fa-window-maximize desk" id="desk4"></i>
      </div>
    </div>

    <div class="container right" id="right">
      <div class="widg" id="cpu">
        <i class="fa fa-spinner"></i>
        <span class="cpu-output"></span>
      </div>
      <div class="widg" id="mem">
        <i class="fas fa-server"></i>
        <span class="mem-output"></span>
      </div>

      <div class="widg" id="hdd">
        <i class="fas fa-hdd"></i>
          <span class="hdd-output"></span>
      </div>
    </div>

  </div>
</div>
  """

#
# ─── RENDER ─────────────────────────────────────────────────────────────────
#

update: ( output, domEl ) ->
  output = output.split( /:::/g )

  battery = output[ 0 ]
  time   = output[ 1 ]
  wifi = output[ 2 ]
  volume = output[ 3 ]
  cpu = output[ 4 ]
  mem = output[ 5 ]
  hdd = output[ 6 ]
  date = output[ 7 ]
  focus = output[ 8 ]
  playing = output[ 9 ]
  ismuted = output[ 10 ]
  ischarging = output[ 11 ]
  activedesk = output[ 12 ]

  # Focus
  focus = focus.split( / /g )[ 0 ]
  # Music

  div = $(domEl)

  $( ".playing" )    .text( "#{ playing }" )
  $( ".time-output" )    .text( "#{ time }" )
  $( ".date-output" )    .text( "#{ date }" )
  $( ".battery-output") .text("#{ battery }")
  $( ".wifi-output") .text("#{ wifi }")
  $( ".cpu-output") .text("#{ cpu }")
  $( ".mem-output") .text("#{ mem }")
  $( ".hdd-output") .text("#{ hdd }")
  $( ".window-output" ).text( "#{ focus }" )

  $(domEl).find(".active").removeClass("active")
  $(domEl).find("#desk"+activedesk).addClass('active')

  @handleBattery( domEl, Number( battery.replace( /%/g, "" ) ), ischarging )
  @handleVolume( Number( volume ), ismuted )
  @handleSysmon( domEl, Number( cpu ), '#cpu' )
  @handleSysmon( domEl, Number( mem.replace( /%/g, "") ), '#mem' )
  @handleSysmon( domEl, Number( hdd.replace( /%/g, "") ), '#hdd' )

#
# ─── HANDLE BATTERY ─────────────────────────────────────────────────────────
#

handleBattery: ( domEl, percentage, ischarging ) ->
  div = $( domEl )

  batteryIcon = switch
    when percentage <=  12 then "fa-battery-empty"
    when percentage <=  25 then "fa-battery-quarter"
    when percentage <=  50 then "fa-battery-half"
    when percentage <=  75 then "fa-battery-three-quarters"
    when percentage <= 100 then "fa-battery-full"


  if percentage >= 20
    div.find('.battery').css('color', colors.green )
  else if percentage >= 10
    div.find('.battery').css('color', colors.yellow )
  else
    div.find('.battery').css('color', colors.red )

  if ischarging == "true"
    batteryIcon = "fas fa-bolt"
  $( ".battery-icon" ).html( "<i class=\"fa #{ batteryIcon }\"></i>" )
#
# ─── HANDLE VOLUME ─────────────────────────────────────────────────────────
#

handleVolume: ( volume, ismuted ) ->
  volumeIcon = switch
    when volume ==   0 then "fa-volume-off"
    when volume <=  50 then "fa-volume-down"
    when volume <= 100 then "fa-volume-up"


  if ismuted != 'true'
    $( ".volume-output") .text("#{ volume }")
  else
    $( ".volume-output") .text("Muted")
    volumeIcon = "fa-volume-off"

  $( ".volume-icon" ).html( "<i class=\"fa #{ volumeIcon }\"></i>" )

#
# ─── HANDLE CLICKS ────────────────────────────────────────────────────────
#
afterRender: (domEl) ->
    $(domEl).on 'click', '#music', => @run "open /Applications/iTunes.app"
    $(domEl).on 'click', '#home', => @run "open ~"
    $(domEl).on 'click', '#browser', => @run "open /Applications/Safari.app"
    $(domEl).on 'click', '#mail', => @run "open /Applications/Mail.app"
    $(domEl).on 'click', '#messages', => @run "open /Applications/WhatsApp.app"

# ──────────────────────────────────────────────────────────────────────────────
#
# ─── COLOR SYSMON –─────────────────────────────────────────────────────────
#
handleSysmon: ( domEl, sysmon, monid ) ->
  div = $(domEl)

  if sysmon <= 10
    div.find(monid).css('color', colors.white )
  else if sysmon <= 20
    div.find(monid).css('color', colors.cyan )
  else if sysmon <= 40
    div.find(monid).css('color', colors.blue )
  else if sysmon <= 50
    div.find(monid).css('color', colors.green )
  else if sysmon <= 75
    div.find(monid).css('color', colors.yellow )
  else
    div.find(monid).css('color', colors.red )

<<<<<<< HEAD:supernerd.widget/display.coffee
=======
#
# ─── STYLE ─────────────────────────────────────────────────────────────────
#
>>>>>>> origin/cssdev:display.coffee

# ──────────────────────────────────────────────────────────────────────────────

#############################
# Shows errors if they occur
showError: (err) ->
	if @content
		@content.html '<div class="error">' + err + '</div>'
