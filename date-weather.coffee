apiKey: "d959452d7b7d505c92f8957d3742ebc9"
location: "38.71667,-9.13333"

# [API KEY] : Get it for free at forecast.io. You'll need a (free) developer account.
#             IT LOOKS LIKE THIS: 2cce4b1c672a119283665a74e987fcde (this one's fake)

# I'M NOT SURE IF THIS IS ACTUALLY WORKING. PLEASE LET ME KNOW IF IT SHOWS THE
# THE CORRECT WEATHER FOR YOUR LOCATION.

# Powered by: DARKSKY   https://darksky.net/poweredby/

commands =
  date  : "date +\"%a %d %b\""
  weather : "sh ./supernerd.widget/scripts/getweather.sh 'd959452d7b7d505c92f8957d3742ebc9' '38.71667,-9.13333'"

iconMapping:
  "rain"                :"fas fa-tint"
  "snow"                :"fas fa-snowflake"
  "fog"                 :"fas fa-braille"
  "cloudy"              :"fas fa-cloud"
  "wind"                :"fas fa-align-left"
  "clear-day"           :"fas fa-sun"
  "mostly-clear-day"    :"fas fa-adjust"
  "partly-cloudy-day"   :"fas fa-cloud"
  "clear-night"         :"fas fa-star"
  "partly-cloudy-night" :"fal fa-adjust"
  "unknown"             :"fas fa-question"

command: "echo " +
         "$(#{ commands.date }):::" +
         "$(#{ commands.weather }):::"

refreshFrequency: '30m'

render: ( ) ->
  """
<div class="widg" id="date">
  <span class="output nohidden" id="date-output"></span>

  <div class="output" id="weather">
    <div class="icon-container" id="weather-icon-container">
      <i class="fa fa-sun"></i>
    </div>
  </div>
  <span class="output" id="weather-output">Loading...</span>

</div>
  """

update: ( output, domEl ) ->
  output = output.split( /:::/g )

  values = []

  values.date = output[ 0 ]
  values.weather = output[ 1 ]

  controls = ['date', 'weather']
  for control in controls
    outputId = "#"+control+"-output"
    currentValue = $("#{outputId}").value
    updatedValue = values[control]

    if updatedValue != currentValue
      $("#{ outputId }").text("#{ updatedValue }")

      if control is 'weather'
        @handleWeather( domEl, values.weather )


#
# ─── HANDLE WEATHER ─────────────────────────────────────────────────────────
#
handleWeather: ( domEl, weatherdata ) ->
  data  = JSON.parse(weatherdata)
  $(domEl).find('#weather-output').text(weatherdata)
  today = data.daily?.data[0]

  return unless today?
  date  = @getDate today.time

  $(domEl).find('#weather-output').text(String (Math.round(today.temperatureMax)+'°'))
  $(domEl).find('#weather-ext-output').text(String(today.summary))
  $(domEl).find( "#weather-icon-container" ).html( "<i class=\"fa #{ @getIcon(today) }\"></i>" )


  $(domEl).find("#weather").removeClass('red')
  $(domEl).find("#weather").removeClass('white')
  $(domEl).find("#weather").removeClass('cyan')
  if data.temperatureMax >= 26
    $(domEl).find('#weather').addClass('red')
    $(domEl).find('#weather-icon-container').addClass('red')
  else if data.temperatureMax >= 6
    $(domEl).find('#weather').addClass('white')
    $(domEl).find('#weather-icon-container').addClass('white')
  else
    $(domEl).find('#weather').addClass('cyan')
    $(domEl).find('#weather-icon-container').addClass('cyan')

getIcon: (data) ->
  return @iconMapping['unknown'] unless data

  if data.icon.indexOf('cloudy') > -1
    if data.cloudCover < 0.25
      @iconMapping["clear-day"]
    else if data.cloudCover < 0.5
      @iconMapping["mostly-clear-day"]
    else if data.cloudCover < 0.75
      @iconMapping["partly-cloudy-day"]
    else
      @iconMapping["cloudy"]
  else
    @iconMapping[data.icon]

getDate: (utcTime) ->
  date  = new Date(0)
  date.setUTCSeconds(utcTime)
  date

makeCommand: (apiKey, location) ->
  exclude  = "minutely,hourly,alerts,flags"
  "curl -sS 'https://api.forecast.io/forecast/#{apiKey}/#{location}?units=auto&exclude=#{exclude}'"

#
# ─── UNIVERSAL CLICK AND ANIMATION HANDLING  ─────────────────────────────────────────────────────────
#
afterRender: (domEl) ->
  geolocation.getCurrentPosition (e) =>
    coords     = e.position.coords
    [lat, lon] = [coords.latitude, coords.longitude]
    @commands.weather = @makeCommand(@apiKey, "#{lat},#{lon}")
