<a href="https://www.twilio.com">
  <img src="https://static0.twilio.com/marketing/bundles/marketing/img/logos/wordmark-red.svg" alt="Twilio" width="250" />
</a>

# Rapid Response Kit: Building Conferencing and Broadcasting with Twilio. Level: Intermediate. Powered by Twilio - Ruby on Rails

![](https://github.com/TwilioDevEd/conference-broadcast-rails/workflows/Ruby/badge.svg)

> We are currently in the process of updating this sample template. If you are encountering any issues with the sample, please open an issue at [github.com/twilio-labs/code-exchange/issues](https://github.com/twilio-labs/code-exchange/issues) and we'll try to help you.

An example application implementing an disaster response kit that allows an organizer to instantly communicate with volunteers.  For a
step-by-step tutorial, [visit this link](https://www.twilio.com/docs/howto/walkthrough/conference-broadcast/ruby/rails).

## Local Development

### Requirements
This project is built using the [Ruby on Rails](http://rubyonrails.org/) web framework with ruby 2.6.3 version.

### Set up
1. First clone this repository and `cd` into it

   ```bash
   $ git clone https://github.com/TwilioDevEd/conference-broadcast-rails.git
   $ cd conference-broadcast-rails
   ```

1. Install the dependencies

   ```bash
   $ bundle install
   ```

1. Copy the sample configuration file and edit it to match your configuration

   ```bash
   $ cp .env.example .env
   ```

   | Config Value  | Description |
   | :-------------  |:------------- |
   `TWILIO_ACCOUNT_SID` / `TWILIO_AUTH_TOKEN` | In [Twilio Account Settings](https://www.twilio.com/console).
   `TWILIO_NUMBER` | You may find [here](https://www.twilio.com/console/phone-numbers/incoming).

1. Make sure the tests succeed

   ```bash
   $ bundle exec rails test
   ```

### Try it out

1. Run the server, the following command will run the application on port 3000.

   ```bash
   $ bundle exec rails server
   ```

1. Expose your application to the wider internet using [ngrok](http://ngrok.com). This step
   **is important** because the application won't work as expected if you run it through
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

That's it!

## Meta

* No warranty expressed or implied.  Software is as is. Diggity.
* The CodeExchange repository can be found [here](https://github.com/twilio-labs/code-exchange/).
* [MIT License](http://www.opensource.org/licenses/mit-license.html)
* Lovingly crafted by Twilio Developer Education.
