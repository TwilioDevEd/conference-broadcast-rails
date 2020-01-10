<a href="https://www.twilio.com">
  <img src="https://static0.twilio.com/marketing/bundles/marketing/img/logos/wordmark-red.svg" alt="Twilio" width="250" />
</a>

# Rapid Response Kit: Building Conferencing and Broadcasting with Twilio. Level: Intermediate. Powered by Twilio - Ruby on Rails

[![Build Status](https://travis-ci.org/TwilioDevEd/conference-broadcast-rails.svg?branch=master)](https://travis-ci.org/TwilioDevEd/conference-broadcast-rails)

> We are currently in the process of updating this sample template. If you are encountering any issues with the sample, please open an issue at [github.com/twilio-labs/code-exchange/issues](https://github.com/twilio-labs/code-exchange/issues) and we'll try to help you.

An example application implementing an disaster response kit that allows an organizer to instantly communicate with volunteers.  For a
step-by-step tutorial, [visit this link](https://www.twilio.com/docs/howto/walkthrough/conference-broadcast/ruby/rails).

## Local Development

This project is built using the [Ruby on Rails](http://rubyonrails.org/) web framework.

1. First clone this repository and `cd` into it

   ```bash
   $ git clone https://github.com/TwilioDevEd/conference-broadcast-rails.git
   $ cd conference-broadcast-rails
   ```

1. Install the dependencies

   ```bash
   $ bundle
   ```

1. Copy the sample configuration file and edit it to match your configuration

   ```bash
   $ cp .env.example .env
   ```
   You can find your `TWILIO_ACCOUNT_SID` and `TWILIO_AUTH_TOKEN` in your
   [Twilio Account Settings](https://www.twilio.com/console).
   You will also need a `TWILIO_NUMBER`, which you may find [here](https://www.twilio.com/console/phone-numbers/incoming).

   Run `source .env` to export the environment variables

1. Make sure the tests succeed
   ```bash
   $ bundle exec rake
   ```

1. Run the server

   ```bash
   $ bundle exec rails s
   ```

1. Expose your application to the wider internet using [ngrok](http://ngrok.com). This step
   is important because the application won't work as expected if you run it through
   localhost.

   ```bash
   $ ngrok http 3000
   ```

   Once ngrok is running, open up your browser and go to your ngrok URL. It will
   look something like this: `http://9a159ccf.ngrok.io`

   You can read [this blog post](https://www.twilio.com/blog/2015/09/6-awesome-reasons-to-use-ngrok-when-testing-webhooks.html)
   for more details on how to use ngrok.

1. Configure Twilio to call your webhooks

   You will also need to configure Twilio to call your application when calls are received on your `TWILIO_NUMBER`. The voice url should look something like this:

   ```
   http://9a159ccf.ngrok.io/conference (POST)
   ```

   ![Configure Voice](http://howtodocs.s3.amazonaws.com/twilio-number-config-all-med.gif)

That's it!

## Meta

* No warranty expressed or implied.  Software is as is. Diggity.
* [MIT License](http://www.opensource.org/licenses/mit-license.html)
* Lovingly crafted by Twilio Developer Education.
