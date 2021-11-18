# Ruby Gems

This document contains the information about Ruby gems we use (not every one, but the crucial ones).

## Development Tools

### `rubocop`

[RuboCop](http://www.rubocop.org) is a Ruby code static analysis tool.

It helps to prevent syntax errors, simple bugs and enforce style guides.

Our RuboCop config is based on the [`standard`](https://github.com/testdouble/standard) gem and
also includes RSpec related cops and a few custom cops.

To run RuboCop use the following command:

```sh
bundle exec rubocop
```

To auto-format the code run:

```sh
bundle exec rubocop -A
```

See the internal [`common-rubocop`](../../gems/common-rubocop/README.md) gem for more.

### `brakeman`

We use [`brakeman`](https://brakemanscanner.org/) to detect security issues in the application code.

We run it on CI, but you can also run it locally:

```sh
bundle exec brakeman
```

Sometimes Brakeman generates false positives we want to ignore.
To do that run Brakeman locally in interactive mode:

```sh
bundle exec brakeman -I
```

**NOTE:** choose `.danger/brakeman.ignore` as input file for ignore config.

### `bundle-audit`

We use [`bundler-audit`](https://github.com/rubysec/bundler-audit) to track security vulnerabilities in our dependencies.

It runs automatically on CI, no need to run it locally.

### `database_consistency`

This tool helps to keep AR models and database in the consistent state: checks for missing validations
or `null` constraints, missing indexes and foreign keys.

Run the check locally:

```sh
bundle exec rails db:consistency_check
```

## Frameworks

### `action_policy`

[Action Policy](https://github.com/palkan/action_policy) is an _authorization_ framework (alternative to [CanCanCan](https://github.com/CanCanCommunity/cancancan) and kind of successor of [Pundit](https://github.com/varvet/pundit)).

Read more in the [documentation](https://actionpolicy.evilmartians.io/), or watch the [RailsConf talk](https://www.youtube.com/watch?v=NVwx0DARDis).

### `action_policy-graphql`

[Action Policy integration for GraphQL](https://github.com/palkan/action_policy-graphql) provides an integration for using Action Policy as an authorization framework for GraphQL applications.

Read more in the [documentation](https://actionpolicy.evilmartians.io/#/graphql).

### `activejob-status`

[ActiveJob Status](https://github.com/inkstak/activejob-status) A simple monitoring status for ActiveJob. To track a job status call `track_status` in the job implementation class. A mobile client can retrieve the job status with `jobStatus` GraphQL query.

### `graphql-ruby`

[GraphQL](https://graphql.org) is a query language which we use for client-server communication.

We use [`graphql-ruby`](http://graphql-ruby.org) gem on backend side.

Resources:
- [GraphQL on Rails](https://speakerdeck.com/exaspark/graphql-on-rails)
- [How to GraphQL](https://www.howtographql.com)
- [Multipart Uploads with GraphQL](https://github.com/jaydenseric/graphql-multipart-request-spec)

**NOTE:** we using the modern, object-oriented, API for `graphql-ruby`; so, there are many outdated post/tutorials out there–just skip them!

## Libraries

### `anyway_config`

We use [anyway_config](https://github.com/palkan/anyway_config) gem under the hood, which allows us to manage different sources of data transparently.

See the [configuration article](../configs.md) for more.

### `dry-initializer`

We use [Dry Initializer](https://github.com/dry-rb/dry-initializer) to standardize Service Objects (it's included into `CoreBy::Base::Service`), e.g.:

```ruby
class MyService < CoreBy::Base::Service
  # define params and options
  param :user
  option :some_type

  # define call method
  def call
    # here you can access `user` and `some_type`
  end
end

# Calling a service object
MyService.call(User.first, some_type: "foo")
```

### `jwt_sessions`

We use [JWT](https://jwt.io) for mobile client authentication backed by [`jwt_sessions`](https://github.com/tuwukee/jwt_sessions) gem.

Resources:
- [Rails API + JWT auth](https://blog.usejournal.com/rails-api-jwt-auth-vuejs-spa-eb4cf740a3ae)

### `sorcery`

[Sorcery](https://github.com/sorcery/sorcery) is an authentication library for Rails app which provides passwords/tokens/sessions management.

Unlike `devise`, it doesn't contain tons of useless auto-generated code and provides only a bare minimum to build custom authentication system.

[See also authentication docs](./authentication.md).

### `schked`

[Schked](https://github.com/bibendi/schked) is a cron replacement. It runs as a lightweight, long-running Ruby process.

To run Schked localy use the following command:

```sh
bundle exec schked start
```

### `after_commit_everywhere`

[after_commit everywhere](https://github.com/Envek/after_commit_everywhere) allows to use ActiveRecord transactional callbacks outside of ActiveRecord models, literally everywhere in your application.

### `discard`

[Discard](https://github.com/jhawthorn/discard) is a simple ActiveRecord mixin to add conventions for flagging records as discarded.

### `redis-mutex`

[redis-mutex](https://github.com/kenn/redis-mutex) is a distributed mutex using Redis. Used in service objects to prevent double runs of the service with identical arguments at the same time.

```ruby
class Compose < CoreBy::Base::Service
  param :room

  def call
    with_lock { heavy_lifting_work }
  end

  private

  def mutex_key
    room
  end
end

Compose.new(room).locked?
```

## ActiveRecord Extensions

We have multiple gems which extend ActiveRecord functionality (mostly for PostgreSQL specific features).

We use Postgres as a [Full-text search feature](https://www.postgresql.org/docs/current/static/textsearch.html) along with [`pg_search`](https://github.com/Casecommons/pg_search) gem.

We use [`activerecord-postgres_enum`](https://github.com/bibendi/activerecord-postgres_enum) to manage DB enum data types.

We use [`fx`](https://github.com/teoljungberg/fx) to manage DB functions and triggers.

We use [`postgresql_cursor`](https://github.com/afair/postgresql_cursor) for handling large Result Sets. See the [postgresql documentation](https://www.postgresql.org/docs/current/static/plpgsql-cursors.html) for more information.

We use [`counter_culture`](https://github.com/magnusvk/counter_culture) to use counter caches. This gem will keep counters correctly updated when using discard for soft-delete support.

We use [`mobility`](https://github.com/shioyama/mobility) for storing and retrieving translations as attributes on a model.

We use ['paper_trail'](https://github.com/paper-trail-gem/paper_trail) to log changes on some major models.
Don't forget to add new significant columns to existing configured models because we don't log all the changes to prevent bloat on the versions table.

Other noticable PostgreSQL feature–unstructured data types (such as [arrays](https://www.postgresql.org/docs/current/static/arrays.html) and [JSONB](https://www.postgresql.org/docs/current/static/datatype-json.html)) are covered by [`store_attribute`](https://github.com/palkan/store_attribute/tree/master/lib) gem which adds an ability to type cast store values. Most of the models have `extra` JSONB column, which is used to store some _meta_ information (which we don't need to use in queries). That's where we typically use `store_attribute` (e.g. to store boolean values in stores).

We use Arel for complex queries. Arel is a core part of ActiveRecord (existed as a separated gem until recently, now it's a part of Rails), it builds and manipulates _abstract syntax trees_ for SQL queries.

Arel (sometimes) is better than writing plain SQL, 'cause it's reusable, handles type casting, etc. But too much Arel could make code less readable and understandable.

Unfortunately, there is no good documentation for Arel. Some useful resources:
- [Arel Cheatsheet](https://devhints.io/arel)
- [Arel Cheatsheet 2](https://www.calebwoods.com/2015/08/11/advanced-arel-cheat-sheet/)
- [Scuttle: A SQL and Arel Editor](http://www.scuttle.io)
- [Common Table Expressions in ActiveRecord](https://sonnym.github.io/2017/06/05/common-table-expressions-in-activerecord-a-case-study-of-quantiles/) (_hardcore_)
- [The definitive guide to Arel](https://jpospisil.com/2014/06/16/the-definitive-guide-to-arel-the-sql-manager-for-ruby.html)
