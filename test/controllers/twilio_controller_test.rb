require 'test_helper'

class TwilioControllerTest < ActionController::TestCase
  # called before every single test
  def setup
    ENV['TWILIO_NUMBER'] = "+15005550006"
  end

  test "should serve conference page" do
    get :conference
    assert_response :success
  end

  test "should Say and Gather something at /conference" do
    post :join_conference
    assert response.body.include? '<Gather action="conference/connect">'
    assert response.body.include? '<Say>Press 1 to join as a listener.</Say>'
    assert response.body.include? '<Say>Press 2 to join as a speaker.</Say>'
    assert response.body.include? '<Say>Press 3 to join as the moderator.</Say>'
    assert_response :success
  end

  test "should Join conference as listener when 1 is chosen" do
    post :conference_connect, :params => { "Digits": "1" }
    assert response.body.include? 'Dial'
    assert response.body.include? 'Conference'
    assert response.body.include? 'muted="true"'
    assert_response :success
  end

  test "should Join conference as speaker when 2 is chosen" do
    post :conference_connect, :params => { "Digits": "2" }
    assert response.body.include? 'Dial'
    assert response.body.include? 'Conference'
    assert response.body.include? 'muted="false"'
    assert_response :success
  end

  test "should Join conference as moderator when 3 is chosen" do
    post :conference_connect, :params => { "Digits": "3" }
    assert response.body.include? 'Dial'
    assert response.body.include? 'Conference'
    assert response.body.include? 'startConferenceOnEnter="true"'
    assert response.body.include? 'endconferenceOnExit="true"'
    assert_response :success
  end

  test "should serve broadcast page" do
    get :broadcast
    assert_response :success
  end

  test "should Record a new message when user clicks 'Make Recording'" do
    post :broadcast_record
    assert response.body.include? 'Say'
    assert response.body.include? 'record your message'
    assert_response :success
  end

  test "should test something here" do
    post :broadcast_play, :params => { recording_url: 'some_url' }
    assert response.body.include? '<Play>some_url</Play>'
  end
end
