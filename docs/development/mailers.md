# Mailers

🔗 [Rails Guides](https://edgeguides.rubyonrails.org/action_mailer_basics.html)

To make mailer classes independent on the particular email mockups (and thus do not have application specific logic in engines), we use the techniques described below.

## Use locales for subject generation

We can store emails subjects in locale files (e.g. `config/locales/en.yml`).

The would allow us to easily overwrite the engine's data at the root app level
(because app-level locales have higher precedence).

That's how to use the locales for `subject` fields:

```ruby
class MyMailer < CoreBy::Base::Mailer
  def mailer_method
    mail subject: t(".subject")
    # this is a shortcut for
    mail subject: t("my_mailer.mailer_method.subject")
  end
end
```

## Overriding templates in the main app

In-engine's template should only contain a basic e-mail contents, without caring about
the e-mail look.

**The actual templates must be stored in the main app** (`app/views/<engine>/<mailer>/...`) (they will take precedence over the ones defined in the engine itself).

## Templates structure

The basic mailer template layout consists of the following _parts_ (see `app/views/layouts/mailer.html.erb`):
- `:title` – email title
- `:content` – main email content
- `:action` (optional) – action-button at the bottom of the email text (rendered using the `shared/mailer/action` partial).

## Mailer config

We store some meta information in the `:mailer` config (`config/mailer.yml`).

The config class is defined in `CoreBy` engine (`engines/core_by/app/configs/core_by/mailer_config.rb`).

To access the mailer config in templates uses `mail_config` method.

## Mailer assets

Put static mailers assets (images, etc.) into `public/mail-assets` folder.

To use them in templates use the `image_url` helper and specify the path from `public/` **with the leading slash**: `image_url("/mail-assets/logo.png")`.

## Email previews

We use Action Mailer [previewing emails](https://guides.rubyonrails.org/action_mailer_basics.html#previewing-emails) feature to perform visual testing of the templates.

To see the previews you need to:
- run the Rails server (`docker-compose up rails` with Docker)
- go to [localhost:3000/rails/mailers](http://localhost:3000/rails/mailers).

### Adding previews

The previews must be stored in the corresponding engine's dir (under `spec/previews`) and preview classes **must be** namespaced (i.e. `class CoreBy::UserMailerPreview`).

**NOTE:** we automatically test email previews (that they do not fail to render) via request specs (see `spec/requests/mailers_previews_spec.rb`).
