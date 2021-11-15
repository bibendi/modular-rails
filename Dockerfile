ARG RUBY_VERSION

# === Base image =======================================================================================================

FROM ruby:${RUBY_VERSION}-slim-buster as base

ARG NODE_MAJOR
ARG POSTGRES_VERSION
ARG BUNDLER_VERSION
ARG YARN_VERSION

# Common dependencies
RUN apt-get update -qq \
  && apt-get dist-upgrade -y \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    pkg-config \
    curl \
    wget \
    less \
    git \
    shared-mime-info \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

# Node
RUN curl -sSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash -

# Postgres client
RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && echo 'deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main' ${POSTGRES_VERSION} > /etc/apt/sources.list.d/pgdg.list

# Yarn
RUN curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

# App's dependencies
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    postgresql-client-${POSTGRES_VERSION} \
    libpq-dev \
    nodejs \
    python-dev \
    yarn=${YARN_VERSION}-1 \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

RUN mkdir /app

# Bundler
ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3
RUN gem update --system \
  && gem install --default bundler:${BUNDLER_VERSION}

EXPOSE 3000


# === Development image ================================================================================================

FROM base as development

ENV RAILS_ENV=development

RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    vim \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

WORKDIR /app

CMD ["/usr/bin/bash"]


# === Image that installs libraries and compiles assets for production image ===========================================

FROM base as production-builder

# Configure bundler paths after installing bundler itself to avoid problems with creating
ENV RAILS_ENV=production \
  LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3 \
  BUNDLE_APP_CONFIG=/home/web/bundle \
  BUNDLE_PATH=/home/web/bundle \
  GEM_HOME=/home/web/bundle

# Container user
RUN groupadd --gid 1005 web \
  && useradd --uid 1005 --gid web --shell /bin/bash --create-home web

USER web

RUN mkdir /home/web/app

WORKDIR /home/web/app

# JS packages
COPY --chown=web:web package.json yarn.lock ./

RUN yarn install --check-files

# Ruby gems
COPY --chown=web:web Gemfile Gemfile.lock .ruby-version .rails-version ./
COPY --chown=web:web engines/core_by/*.gemspec ./engines/core_by/
COPY --chown=web:web engines/auth_by/*.gemspec ./engines/auth_by/
COPY --chown=web:web engines/tasks_by/*.gemspec ./engines/tasks_by/
COPY --chown=web:web gems/common-factory/*.gemspec ./gems/common-factory/
COPY --chown=web:web gems/common-rubocop/*.gemspec ./gems/common-rubocop/
COPY --chown=web:web gems/common-testing/*.gemspec ./gems/common-testing/

RUN mkdir $BUNDLE_PATH \
  && bundle config --local deployment 'true' \
  && bundle config --local path "${BUNDLE_PATH}" \
  && bundle config --local without 'development test' \
  && bundle config --local clean 'true' \
  && bundle config --local no-cache 'true' \
  && bundle install --jobs=${BUNDLE_JOBS} \
  && rm -rf $BUNDLE_PATH/ruby/2.7.0/cache/* \
  && rm -rf /home/web/.bundle/cache/*

# Code
COPY --chown=web:web . .

# Precompile assets
ARG SECRET_KEY_BASE=qwerty
ARG DATABASE_URL=postgres://postgres:postgres@postgres:5432
ARG DATABASE_DIRECT_URL=postgres://postgres:postgres@postgres:5432
ARG TIMESCALE_URL=postgres://postgres:postgres@postgres:5432
ARG REDIS_URL=redis://redis:6379/0
ARG CACHE_REDIS_URL=redis://redis-cache:6379/0
ARG IMGPROXY_ENDPOINT=http://localhost:3080

RUN EAGER_LOAD=0 bundle exec rails assets:precompile


# === Production image =================================================================================================

FROM ruby:${RUBY_VERSION}-slim-buster AS production

ARG POSTGRES_VERSION

# Common dependencies
RUN apt-get update -qq \
  && apt-get dist-upgrade -y \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    curl \
    gnupg2 \
    less \
    tzdata \
    time \
    locales \
    shared-mime-info \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log \
  && update-locale LANG=C.UTF-8 LC_ALL=C.UTF-8

# Postgres client for rails dbconsole -p
RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && echo 'deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main' ${POSTGRES_VERSION} > /etc/apt/sources.list.d/pgdg.list \
  && apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    postgresql-client-${POSTGRES_VERSION} \
    libpq5 \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

RUN gem update --system

ENV RAILS_ENV=production \
  MALLOC_ARENA_MAX=2 \
  BUNDLE_APP_CONFIG=/home/web/bundle \
  BUNDLE_PATH=/home/web/bundle \
  GEM_HOME=/home/web/bundle \
  PATH="/home/web/app/bin:${PATH}" \
  LANG=C.UTF-8 \
  LC_ALL=C.UTF-8

# Container user
RUN groupadd --gid 1005 web \
  && useradd --uid 1005 --gid web --shell /bin/bash --create-home web

RUN mkdir /home/web/app

WORKDIR /home/web/app

USER web

EXPOSE 3000

RUN gem install --default bundler -v "${BUNDLER_VERSION}"

# Code
COPY --chown=web:web . .

# Artifacts
COPY --from=production-builder $BUNDLE_PATH $BUNDLE_PATH
COPY --from=production-builder /home/web/app/tmp/graphdoc /home/web/app/tmp/graphdoc
COPY --from=production-builder /home/web/app/tmp/graphql /home/web/app/tmp/graphql
COPY --chown=web:web --from=production-builder /home/web/app/tmp/cache/bootsnap* /home/web/app/tmp/cache/

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
