# repro-client

Repro API Client

## Install

```
$ gem install repro-client
```

or add to your Gemfile

```ruby
gem 'repro-client', github: 'itkrt2y/repro-client'
```

## Usage

### [Send push notification](http://docs.repro.io/en/dev/push-api/index.html)

```ruby
client = Repro::Client.new('repro_api_token')
user_ids = [1, 2, 3]
payload = { message: 'Hello Repro!' }
client.push('push_id', user_ids, payload)
```

#### [Payload format](http://docs.repro.io/en/dev/push-api/index.html#id7)

1. [Standard format](http://docs.repro.io/en/dev/push-api/index.html#id8)

```ruby
{
  message: 'Hello Repro!',
  deeplink_url: 'url',
  sound: 'sound'
}
```

2. [Custom](http://docs.repro.io/en/dev/push-api/index.html#json)

You need to set the content as Hash

### [Update user profile](http://docs.repro.io/en/dev/user-profile-api/index.html)

```ruby
client = Repro::Client.new('repro_api_token')
user_id = 'user-123'
payload = [{ key: 'Job', type: 'string', value: 'Developer' }]
client.update_user_profiles(user_id, payload)
```

#### Payload format

[See Repro Official Document](http://docs.repro.io/en/dev/user-profile-api/index.html#user-profiles-payload)

## Supported Ruby Versions

Ruby 2.3.0 or higher
