# Deployment Configuration

## Environment Variables

This table contains a list of the environment variables and where they come from.

NAME                       | REQUIRED     | DESCRIPTION
---------------------------|--------------|---------------
`RAILS_MASTER_KEY`         | ✅           | **NOTE**: the key is stored in the Keybase team folder
`DATABASE_URL`             | ✅           | Primary database url
`DATABASE_DIRECT_URL`      | ✅ (prod)    | Direct connection to DB bypassing the connection poller. It's used for Postgres cursors.
`TIMESCALE_URL`      | ✅ (prod)    | Statistics database url
`ELASTICSEARCH_URL`      | ✅ (prod)    | Elasticsearch database url
`REDIS_URL`                | ✅           | Can be specified as `redis_url` in encrypted credentials
`ANYCABLE_REDIS_URL`       | ✅           |
`CACHE_REDIS_URL`          | ✅           | Can be specified as `cache_redis_url` in encrypted credentials
`WEB_CONCURRENCY`\*        |              | Number of Puma workers (processes) (**default: 2**)
`RAILS_MAX_THREADS`\*      |              | Used as a thread pool size for Puma, Faktory, and DB connection pool size (**default: 5**)
`SENTRY_CURRENT_ENV`       | ✅ (staging)  | Set to `staging` / `review` for staging and reviews apps respectively

\* Be careful with this params and always consider external deps (such as databases) limits when changing them. See [Postgres](../infrastructure/postgres.md) and [Redis](../infrastructure/redis.md) docs.
