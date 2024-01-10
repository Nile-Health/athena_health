# Nile Core

## To use gem locally for development

Build gem (replace # with version):

```
gem build athena_health.gemspec
gem install athena_health-2.0.#.gem
```

Temporarily update docker-compose.yml in Nile-Core to add the following under rails:volumes:

```
- /path/to/athena/health/dev/:/athena_health
```

Rebuild docker containers in Nile-Core directory:

```
docker-compose up -d --build
```

Temporarily remove Gemfury source from Gemfile in Nile-Core and add the following:

```
gem 'athena_health', path: '/athena_health/'
```

Run bundle install in Nile-Core directory:

```
docker-compose run rails bash -c "bundle exec bundle install"
```

Nile-Core will now use local gem. Every time you make a change, rebuild gem and install and re-run bundle install in Nile-Core.

## To test gem locally from the command line

A very lightweight way to test this gem is locally using irb:

```
# Start irb with local version of gem:
# irb -I lib -r athena_health


require 'athena_health'

client = AthenaHealth::Client.new(
  client_id: <insert client_id here>,
  secret: <insert client_secret here>
)

# Then run commands using the client, for example:
client.all_order_types(practice_id: <insert practice_id here>)
```

## To upload new version of gem to Gemfury

Replace # with the version number nad TOKEN with the push token stored in 1password.

```

git push fury master
gem build athena_health.gemspec
curl -F package=@athena_health-2.0.#.gem https://TOKEN@push.fury.io/nile-health/

```
## Bundle update on Nile-Core

After uploading a new version to Gemfury, remember to do a "bundle update" on NileCore 
```
docker-compose run rails bash -c "bundle exec bundle update"
```


[![Gem Version](https://badge.fury.io/rb/athena_health.svg)](https://badge.fury.io/rb/athena_health)
[![Continuous integration](https://github.com/HealthTechDevelopers/athena_health/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/HealthTechDevelopers/athena_health/actions/workflows/ci.yml)

# AthenaHealth

Ruby wrapper for [Athenahealth API](https://docs.athenahealth.com/api/).

## Updating from gem version 1 (Mashery API) to gem version 2 (https://developer.api.athena.io/ API)

There is only one change needed to upgrade, and that is how you create a new client.

The new signature has 3 keywords:
`AthenaHealth::Client.new(production:, client_id: secret:)`

- `production:`
  - `boolean`
  - default `false`
  - this replaces the `version:` keyword
  - indicates if you want to access the preview enviroment or the production enviroment.
- `client_id:`
  - `string`
  - no default
  - this replaces the `key:` keyword
  - this should be your **Client ID** from the developer portal
- `secret:`
  - `string`
  - no default
  - this should be your **Secret** from the developer portal

### Example

#### Gem v1 code

Preview:

````

client = AthenaHealth::Client.new(
version: 'preview1',
key: "my_client_id",
secret: "my_secret"
)

```
Production:
```

client = AthenaHealth::Client.new(
version: 'v1',
key: "my_client_id",
secret: "my_secret"
)

```
#### Gem v2 code
Preview:
```

client = AthenaHealth::Client.new(
production: false,
client_id: "my_client_id",
secret: "my_secret"
)

```
Production:
```

client = AthenaHealth::Client.new(
production: true,
client_id: "my_client_id",
secret: "my_secret"
)

```

## Examples

For some examples of how to use this library, check out [the project wiki](https://github.com/HealthTechDevelopers/athena_health/wiki).

## Contributing

### Local development

 - Check out the repository
 - Ensure you have Ruby and the Bundler gem installed
 - Install the gem dependencies with `bundle`
 - Setup Environment Variables before testing new endpoints, you'll need the following:
  - ATHENA_TEST_CLIENT_ID
  - ATHENA_TEST_SECRET
  - ATHENA_TEST_ACCESS_TOKEN

#### Testing

You can run all of the tests using `rake`.

### Overview

Contributions from the community are very welcome, including but not limited to new endpoints, new/better documentation and refactoring.

Forking the repo and submitting pull requests is just fine.

There is no specific roadmap and so far features have been added when the community needed them.

We have tried to have all the versions be backward compatible so far. If we're going to have breaking changes, we can revisit when we have a pull request.
```
````
