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
    post :join_conference, :From => "15556505813"
    assert response.body.include? "Gather"
    assert response.body.include? "Say"
    assert_response :success
  end

  test "should Join conference as listener when 1 is chosen" do
    get :conference_connect, From: "15556505813", Digits: '1'
    assert response.body.include? 'Dial'
    assert response.body.include? 'Conference'
    assert response.body.include? 'muted="true"'
    assert_response :success
  end

  test "should Join conference as speaker when 2 is chosen" do
    get :conference_connect, From: "15556505813", Digits: '2'
    assert response.body.include? 'Dial'
    assert response.body.include? 'Conference'
    assert response.body.include? 'muted="false"'
    assert_response :success
  end

  test "should Join conference as moderator when 3 is chosen" do
    get :conference_connect, From: "15556505813", Digits: '3'
    assert response.body.include? 'Dial'
    assert response.body.include? 'Conference'
    assert response.body.include? 'startConferenceOnEnter="true"'
    assert_response :success
  end

  test "should serve broadcast page" do
    get :broadcast
    assert_response :success
  end

  test "should Record a new message when user clicks 'Make Recording'" do
    get :broadcast_record, From: "15556505813"
    assert response.body.include? 'Say'
    assert response.body.include? 'record your message'
    assert_response :success
  end

end
