# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  lastRecording = new Date('2000-09-27')
  getRecordings= ->
    $.ajax
      url: "/fetch_recordings"
      dataType: "json"
      error: (jqXHR, textStatus, errorThrown) ->
        $('body').append "AJAX Error: #{textStatus}"
      success: (data, textStatus, jqXHR) ->
        showRecordings(data)

  showRecordings= (recordings) =>
    newestRecording = new Date(recordings[0]['date'])
    if newestRecording > lastRecording
      lastRecording = newestRecording
      populateSelect(recordings)

  populateSelect= (recordings) =>
    select = $('#selectRecordings')
    select.empty()
    for recording in recordings
      do (recording) ->
        select.append(
          $("<option></option>").val(recording.url).html(recording.date)
        )

  $('.call-me').click (e) =>
    e.preventDefault()
    phoneNumber = $('#recordingNumber').val()
    $.post "/call_recording", {phone_number: phoneNumber}
      .done (data)->
        $('.recording-status').text('Status: Recording in Progress')
        setTimeout =>
          $('.recording-status').text('Status: Recording complete!')
        , 20000


  $('.show-make').click (e) ->
    e.preventDefault()
    $('.make-recording').addClass 'slide-down'


  $('#selectRecordings').on 'change', (e) ->
    getRecordings()
    selectedUrl = $('#selectRecordings option:selected').val()
    $('#recording-audio').attr('src', selectedUrl)
    $('#recording-url').attr('value', selectedUrl)


  $('.preview-btn').click (e) ->
    e.preventDefault()
    document.getElementById('recording-audio').play();


  if window.location.pathname == '/broadcast'
    getRecordings()


