require 'twilio-ruby'
require 'sanitize'


class TwilioController < ApplicationController

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

  private

  def listener_twiml
    
    return response
  end
end