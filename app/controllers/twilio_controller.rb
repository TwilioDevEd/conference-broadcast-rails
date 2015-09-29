require 'twilio-ruby'
require 'sanitize'
require 'csv'


class TwilioController < ApplicationController
  before_action :set_client_and_number, only: [:start_call_record, :broadcast_send, :fetch_recordings]

  # GET /conference
  def conference
    @conference_number = ENV['RR_CONFERENCE_NUMBER']
  end

  # POST /conference
  def join_conference
    twiml = Twilio::TwiML::Response.new do |r|
      r.Say "You are about to join the Rapid Response conference"
      r.Gather action: "conference/connect" do |g|
        g.Say "Press 1 to join as a listener."
        g.Say "Press 2 to join as a speaker."
        g.Say "Press 3 to join as the moderator."
      end 
    end
    # can also use .text here, which is aliased to .to_xml in twilio-ruby
    # render xml: twiml.text
    render xml: twiml.to_xml
  end

  # POST /conference/connect
  def conference_connect
    case params['Digits']
    when "1" # listener
      @muted = "true"
    when "3" # moderator
      @moderator = "true"
    end

    twiml = Twilio::TwiML::Response.new do |r|
      r.Say "You have joined the conference."
      r.Dial do |d|
        d.Conference "RapidResponseRoom", 
          waitUrl: "http://twimlets.com/holdmusic?Bucket=com.twilio.music.ambient",
          muted: @muted || "false",
          startConferenceOnEnter: @moderator || "false",
          endConferenceOnEnter: @moderator || "false"
      end
    end
    render xml: twiml.to_xml
  end

  # POST /broadcast/record
  def broadcast_record
    twiml = Twilio::TwiML::Response.new do |r|
      r.Say "Please record your message after the beep. Press star to end your recording."
      r.Record finishOnKey: "*"
    end
    render xml: twiml.to_xml
  end

  # POST /broadcast/send
  def broadcast_send
    numbers = CSV.parse(params[:numbers])
    recording = params[:recording_url]
    url = request.base_url + '/broadcast/play?recording_url=' + recording

    numbers.each do |number|
      @client.account.calls.create(
        from: @twilio_number,
        to: number,
        url: url
      )
    end
  end

  # POST /broadcast/play
  def broadcast_play
    recording_url = params[:recording_url]

    twiml = Twilio::TwiML::Response.new do |r|
      r.Play recording_url
    end
    render xml: twiml.to_xml
  end

  # GET /broadcast
  def broadcast
  end

  # POST /call_recording
  def start_call_record
    phone_number = params[:phone_number]

    @client.account.calls.create(
      from: '+15005550006',
      to: phone_number,
      url: request.base_url + '/broadcast/record'
    )
    head :ok
  end

  # GET /fetch_recordings
  def fetch_recordings
    @recordings = []

    @recs = @client.recordings.list().each do |recording|
      result = {
        :url => recording.mp3,
        :date => recording.date_created
      }
      @recordings << result
    end

    render json: @recordings
  end

  private

  def set_client_and_number
    @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    @twilio_number = ENV['TWILIO_NUMBER']
  end

end