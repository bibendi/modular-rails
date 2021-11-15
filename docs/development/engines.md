# Engines & Gems

Rails [engines](https://guides.rubyonrails.org/engines.html) allow us to split a huge monolith into several parts consolidated by common business logic.

We also use _shared_ gems for functionality not related directly to the app (which is usually stored in the `lib/` _garbage bin_).

## Generating

```sh
rails generate engine <name>
```

It should appear at `engines/<name>`.

To generate a gem, run:

```sh
rails generate gem <name>
```

It should appear at `gems/<name>`.

## Tests

We use shared RSpec configuration from [`common-testing`](../../gems/common-testing) gem.

## Running commands in gems/engines

You can install gems or run tests of an engine if you move to the engine's folder.

```sh
cd engines/core_by
bundle install
bundle exec rspec spec/path/to/file_spec.rb:23
bundle exec bin/rails g migration
bundle exec bin/console
```

If you are using [DIP](./dip.md) you can likewise use the above approach:

```sh
cd engines/core_by
dip ls
dip bundle install
dip rspec spec/path/to/file_spec.rb:23
dip rails g migration
dip rails c
```

Also, we have a CLI tool which allows us to run commands – `bin/engem`.

Some examples:

```sh
# show available commands
bin/engem --help

# run a specific test
bin/engem core_by rspec spec/models/core_by/city.rb:5

# run Rails console
bin/engem core_by console

# runs `bundle install`, `rubocop` and `rspec` by default
bin/engem core_by build

# you can omit running rspec/rubocop by providing `--skip-rspec`/`--skip-rubocop` option:
bin/engem common-rubocop build --skip-rspec

# generate a migration
bin/engem core_by rails g migration <name>

# engem automatically detects gems and engines (i.e. libs ubder engines/ and gems/ directories)
# you don't have to specify whether it's a gem or engine
bin/engem gem common-testing build

# you can run command for all engines/gems at once by using "all" name
bin/engem all build

# in that cases the execution halts as soon as the command fails for one of the engines/gems;
# to disable this fail-fast behaviour use `--ignore-failures` switch
bin/engem all build --ignore-failures
```

## Extending engines entities

Extendable entities (models, jobs, services, etc.) from engines provide load hooks
via [ActiveSupport](https://api.rubyonrails.org/classes/ActiveSupport/LazyLoadHooks.html).

All extensions must be store under the `ext/` sub-folder of the corresponding entity folder (e.g. `app/models/ext/<engine model path>` for models).

For example, if you want to extend `User` model in the main app or an engine:

```ruby
# config/initializers/core_by.rb
ActiveSupport.on_load("core_by/user") do
  include Ext::CoreBy::User
end

# app/models/ext/core_by/user.rb
module Ext
  module CoreBy
    module User
      extend ActiveSupport::Concern

      included do
        attr_reader :foo
      end

      def foo?
        !!foo
      end
    end
  end
end
```

## Gemfiles and gemspecs

We define gems/engines dependencies and requirements using multiple files:
- `<gem>/<gem>.gemspec` – this is Gem specification; it defines **requirements** for this gem (for runtime and development); all required libraries (even _local_) must be specified in the gemspec: we use this information when checking _dirtyness_ of gems on CI (see `/.circleci/is-dirty`)
- `<gem>/<gem>-dev.gemspec` – defines development dependencies. We don't use `add_development_dependencies` in main gemspec files because it's some kind of a hack used by Bundler and it doesn't work with _local_ gems.

## Resources

- [The Modular Monolith: Rails Architecture](https://medium.com/@dan_manges/the-modular-monolith-rails-architecture-fb1023826fc4)
- [Modular, composable Gemfiles](https://medium.com/alliants-blog/modular-composable-gemfiles-5545c83b5319)
