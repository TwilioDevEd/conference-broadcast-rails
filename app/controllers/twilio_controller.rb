class TwilioController < ApplicationController
  TWILIO_API_HOST = 'https://api.twilio.com'

  before_action :set_client_and_number, only: [:start_call_record, :broadcast_send, :fetch_recordings, :conference]

  # GET /conference
  def conference
    @conference_number = @twilio_number
  end

  # POST /conference
  def join_conference
    response = Twilio::TwiML::VoiceResponse.new
    response.say(message:"You are about to join the Rapid Response conference")
    gather = Twilio::TwiML::Gather.new(action: 'conference/connect')
    gather.say(message: "Press 1 to join as a listener.")
    gather.say(message: "Press 2 to join as a speaker.")
    gather.say(message: "Press 3 to join as the moderator.")
    response.append(gather)

    render xml: response.to_s
  end

  # POST /conference/connect
  def conference_connect
    case params['Digits']
    when "1" # listener
      @muted = "true"
    when "3" # moderator
      @moderator = "true"
    end

    response = Twilio::TwiML::VoiceResponse.new
    response.say(message: "You have joined the conference.")
    dial = Twilio::TwiML::Dial.new
    dial.conference("RapidResponseRoom",
      wait_url: "http://twimlets.com/holdmusic?Bucket=com.twilio.music.ambient",
      muted: @muted || "false",
      start_conference_on_enter: @moderator || "false",
      endConference_on_exit: @moderator || "false")
    response.append(dial)

    render xml: response.to_s
  end

  # POST /broadcast/record
  def broadcast_record
    response = Twilio::TwiML::VoiceResponse.new
    response.say(message: "Please record your message after the beep. Press star to end your recording.")
    response.record(finish_on_key: "*")

    render xml: response.to_s
  end

  # POST /broadcast/send
  def broadcast_send
    numbers = CSV.parse(params[:numbers])
    recording = params[:recording_url]
    url = "#{request.base_url}/broadcast/play?recording_url=#{recording}"

    numbers.each do |number|
      @client.calls.create(
        from: @twilio_number,
        to: number,
        url: url
      )
    end
  end

  # POST /broadcast/play
  def broadcast_play
    recording_url = params[:recording_url]
    response = Twilio::TwiML::VoiceResponse.new
    response.play(url: recording_url)

    render xml: response.to_s
  end

  # GET /broadcast
  def broadcast
  end

  # POST /call_recording
  def start_call_record
    phone_number = params[:phone_number]

    @client.calls.create(
      from: @twilio_number,
      to: phone_number,
      url: "#{request.base_url}/broadcast/record"
    )
  end

  # GET /fetch_recordings
  def fetch_recordings
    recordings = @client.recordings.list.map do |recording|
      {
        url:  full_recording_uri(recording.uri),
        date: recording.date_created
      }
    end

    render json: recordings
  end

  private

  # returns full uri given partial recording uri
  def full_recording_uri(uri)
    # remove json extension from uri
    clean_uri = uri.sub!('.json', '')

    "#{TWILIO_API_HOST}#{clean_uri}"
  end

  def set_client_and_number
    @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    @twilio_number = ENV['TWILIO_NUMBER']
  end
end
