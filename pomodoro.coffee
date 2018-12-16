command: "echo $(sh ./supernerd.widget/scripts/getpomoclock.sh)"

refreshFrequency: 100

render: ( ) ->
  """
<div class="widg" id="pomo">
  <span class="output nohidden" id="pomo-output"></span>
</div>
  """

update: ( output, domEl ) ->
  el = $(domEl).find("#pomo-output")
  currentValue = el.text()
  updatedValue = output

  if updatedValue != currentValue
    slicedOutput = [output.slice(0, 1), output.slice(1)]
    status = slicedOutput[0]
    time = slicedOutput[1]

    append = if status == 'P' then ' (paused)' else ''

    if status == 'P'
      slicedOutput = [time.slice(0, 1), time.slice(1)]
      status = slicedOutput[0]
      time = slicedOutput[1]

    if status == 'B'
      nextText = 'on a break for ' + time + append
    else if status == 'W'
      nextText = 'working for ' + time + append
    else
      nextText = 'no pomodoro running'

    el.text(nextText)

