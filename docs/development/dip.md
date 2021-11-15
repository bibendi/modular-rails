# Docker on DIP Development Configuration

We have development [Docker configuration]((./docker.md).

In addition to it you can also use [`DIP`](https://github.com/bibendi/dip) – CLI that gives the "native" interaction with applications configured with Docker Compose. It is for the local development only. In practice, it creates the feeling that you work without containers.

To install DIP copy and run the command below:

```sh
gem install dip
```

## Usage

```sh
# list available commands
dip ls

# provision application
dip provision

# run web app with all debuging capabilities (i.e. `binding.irb`)
dip rails s

# run rails console
dip rails c

# run migrations
dip rake db:migrate

# pass env variables into application
dip VERSION=20100905201547 rake db:migrate:down

# simply launch bash within app directory
dip shell

# Additional commands

# update gems or packages
dip bundle install

# run psql console
dip psql

# run redis console
dip redis-cli

# run tests
dip rspec spec/path/to/single/test.rb:23

# shutdown all containers
dip down
```

DIP can be easily integrated into ZSH or Bash shell.
So, there is allow us using all above commands without `dip` prefix. And it looks like we are not using Docker at all (really that's not true).

```sh
eval "$(dip console)"

rails c
rails s
rspec spec/test_spec.rb:23
VERSION=20100905201547 rake db:migrate:down
rake routes | grep graphql
```

But after we get out to somewhere from the project's directory, then all DIP's aliases will be cleared. And if we get back, then DIP's aliases would be restored.
