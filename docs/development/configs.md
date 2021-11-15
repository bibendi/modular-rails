# Configuration

We need way a flexible way to store different kind of credentials in different environments (infrastracture accesses, API keys, project settings, etc.).

We have different types of environments:
- Development
- Testing
- Staging
- Production.

## Two types of configuration parameters

We divide configuration parameters into two types: **settings** and **secrets**.

_Settings_ are used to modify application behaviour (like feature flags) and technical parameters, for example: `WEB_CONCURRENCY`, `RAILS_MAX_THREADS`, `RAILS_SERVE_STATIC_FILES`.

For settings we must have sensible defaults and only override them in production via env vars.

There is no reason to keep them anywhere else.

_Secrets_ could be also divided into two groups: _system_ and _service_.

_System_ settings include DB accesses, for example.

**Application must fail on start if system settings are missing or invalid.**

The second group contains third-party services credentials (API keys, token, whatever).
NOTE: there could be not only _keys/tokens_, but other settings, e.g. CloudFront assets host or project domain name.

## Keeping service secrets

Instead of putting everything into `application.rb` and manually resolve env variables (and keep track of them in production), we use the following approach:
- Store sensitive information in [Rails Credentials](https://edgeguides.rubyonrails.org/security.html#environmental-security) (different sets for each environment, no global set)
- Keep non-sensitive information in named YAML configs
- Allow overriding value via ENV
- Store _local_ development secrets in personal credentials set (`credentials/local.yml.enc`)

We use [anyway_config](https://github.com/palkan/anyway_config) gem under the hood, which allows us to manage different sources of data transparently.

### Generating local secrets

You can keep personal, _local_, secrets in two places:
- in `config/<config_name>.local.yml` files (for non-sensitive information)
- in `config/credentials/local.yml.enc` (for sensitive information).

To edit local credentials run:

```sh
bundle exec rails credentials:edit -e local
```

**NOTE:** local files are loaded only in `development` environment.

## Example

Suppose that we want to add credentials for AWS S3.

We need the following _secrets_: `access_key_id`, `secret_access_key`, `region`, `bucket`.

First, we create a configuration class for this service:

```ruby
# config/settings/aws_config.rb
class AwsConfig < BaseConfig
  attr_config :access_key_id, :secret_access_key, :bucket,
              # we can set default right here
              region: "us-east-1"
end
```

We can initialize this config in the `application.rb` file:

```ruby
# We have to require a file explicitly because an autoload doesn't work in initializers
require_relative "./settings/aws_config"
config.aws = AwsConfig.instance
```

The config is populated using the following data sources (in the provided order):
- `config/aws.yml` file (environment-aware)
- `config/credentials/<environment>.enc` (if any)
- `config/credentials.local.enc` (personal credentials set)
- environment variables (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, etc.)

For example, in `aws.yml` we can keep the following data:

```yml
test:
  # ideally, we shouldn't use S3 in tests at all;
  # but if we do, we must mock the network calls and
  # use these values in fixtures
  access_key_id: "aws-test-key"
  secret_access_key: "aws-test-key"
  bucket: "app-test"

development:
  bucket: "app-dev"

production:
  # it's ok to store the default production bucket as plain text
  bucket: "app-production"

# Note that we also have a staging env
staging:
  bucket: "app-staging"
```

All the sensitive information goes to Rails Credentials:

```yml
# config/credentials/production.enc
# Add settings under config name ("aws")
aws:
  access_key_id: <super-secret-value>
  secret_access_key: <another-secret-value>
```

See [Deployment: Credentials](../deployment/credentials.md) docs on how to manage production/stating credentials.

Sometimes you might need multiple services sharing some credentials (e.g. different AWS services could use the same access keys/secrets).

In that case it makes sense to have two different configuration classes, but share config sources (YML, credentials, env):

```ruby
class AwsS3Config < BaseConfig
  # Use config option for specify how
  # to search for files and which env prefix to use
  config_name :aws

  attr_config :access_key_id, :secret_access_key, :bucket,
              region: "us-east-1"
end

class AwsTranscoderConfig < BaseConfig
  config_name :aws

  attr_config :access_key_id, :secret_access_key,
              :preset_id
end
```

In your yml/credentials file you keep all the data for both configs:

```yml
test:
  access_key_id: "aws-test-key"
  secret_access_key: "aws-test-key"
  bucket: "app-test"
  preset_id: 123
```

## Where to put configs?

Not all the configs must be put under `app/configs` folder, only those satisfied the following criteria:
- you need it in the app's configuration (i.e. in `config/environments/*.rb` and `config/application.rb`)
- it's a _global_ config for the application itself (like `AppConfig`)
- it's shared by multiple _services_ (like AWS credentials).

On the other hand, the config for the specific API client should be put as close to the API client code itself as possible (in the same module/gem).
