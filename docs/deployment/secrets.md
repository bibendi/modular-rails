# Production Credentials

Most of the _secrets_ are stored in the `config/credentials/production.yml.enc` file
(see [configuration docs](../development/configs.md)).

To manage this file you need a **master key**.

The master is stored in the Keybase team folder (`production.key`).

To edit production credentials run the following command:

```sh
# first, copy the key into the buffer
RAILS_MASTER_KEY=<paste the key> bundle exec rails credentials:edit -e production 
```

**NOTE:** for staging and review apps we use a separate credentials set for `staging`.
The is also located in the Keybase folder.
