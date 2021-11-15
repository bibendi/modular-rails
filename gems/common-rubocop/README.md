# Common RuboCop

RuboCop configuration for usage in a project.

Includes:
- base config from [standard](https://github.com/testdouble/standard)
- [`rubocop-rspec`](https://github.com/rubocop-hq/rubocop-rspec) cops

## Installation

Add this line to your application's Gemfile:

```ruby
gem "common-rubocop", path: "gems/common-rubocop"
```

or to your engine's Gemfile and `.gemspec`:

```ruby
# Gemfile
gem "common-rubocop", path: "../../gems/common-rubocop"

# .gemspec
s.add_development_dependency "common-rubocop"
```

## Usage

Add to your `.rubocop.yml`:

```yml
inherit_gem:
  common-rubocop: config/base.yml
```

## Custom cops

- `Lint/Env` – checks for the presence of `ENV` or `Rails.env`.

Use it to prevent environment dependent checks in your code:

```yml
require:
  - common/rubocop/cop/lint_env

Lint/Env:
  Enabled: true
  Exclude:
    - 'lib/tasks/**/*'
    - 'config/environments/**/*'
    - 'config/*.rb'
    - 'spec/*_helper.rb'
    - 'spec/**/support/**/*'
    - 'Rakefile'
    - 'Gemfile'
```
