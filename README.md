# SlackRackOAuth

Zero-dependency Rack middleware for handling Slack's “Add to Slack” button OAuth flow.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'slack_rack_oauth'
```

And then run:

    bundle

## Usage

In your `config.ru` or equivalent:

```ruby
use SlackRackOAuth, {
  # Required. See Slack docs for available scopes. 
  scopes: %w( incoming-webhook bot commands reactions.read emoji.list ),

  # Client ID and secret. If not explicitly set, will automatically detect
  # SLACK_CLIENT_ID and SLACK_CLIENT_SECRET environment variables.
  client_id: 'my-client-id',
  client_secret: 'my-client-secret',

  # Use to override the default path prefix ("/slack/oauth"). Two
  # routes is currently supported:
  #
  #     /slack/oauth/authorize (redirects to the Slack OAuth authorization)
  #     /slack/oauth/callback (your app will need to support this route)
  # 
  path: '/slack/oauth'
}

run MyApp
```

Inside your app, set up a route to handle a `/slack/oauth/callback` GET request.

From within that request, you will be able to receive the callback information
from the `slack.auth` key in the Rack `env`, which will look something like this:

```
{
  "access_token": "xoxp-XXXXXXXX-XXXXXXXX-XXXXX",
  "scope": "incoming-webhook,commands,bot",
  "team_name": "Team Installing Your Hook",
  "team_id": "XXXXXXXXXX",
  "incoming_webhook": {
    "url": "https://hooks.slack.com/TXXXXX/BXXXXX/XXXXXXXXXX",
    "channel": "#channel-it-will-post-to",
     "configuration_url": "https://teamname.slack.com/services/BXXXXX"
  },
  "bot":{
    "bot_user_id":"UTTTTTTTTTTR",
    "bot_access_token":"xoxb-XXXXXXXXXXXX-TTTTTTTTTTTTTT"
  }
}
```

It's up to you how you choose to store that information, and what you want to
show to the user.

In Rails:

```ruby
# routes.rb
get '/slack/oauth/callback', to: 'slack_connections#create'

# controllers/slack_connections.rb
class SlackConnections < ApplicationController
  def create
    slack_auth = request.env['slack.auth']
    fail "TODO: handle data: #{slack_auth.inspect}"
  end
end
```

In Sinatra:

```ruby
get '/slack/oauth/callback' do
  fail "TODO: handle data: #{env['slack.auth']}"
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Aupajo/slack_rack_oauth. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SlackRackOauth project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Aupajo/slack_rack_oauth/blob/master/CODE_OF_CONDUCT.md).
