# Writing GraphQL API

This guide defines a set of rules on how to write GraphQL API using [`graphql-ruby`](http://graphql-ruby.org).

The main purpose of this guide is to leverage the power of GraphQL (i.e. make the usage of
GraphQL features as much efficient as possible).

See also: `common-graphql` [gem docs](~gems/common-graphql/README.md).

## Defining Fields

- **📄  Make sure types and/or fields have descriptions.**
Let's make developing clients easier.

- Always use the built-in [`GraphQL::Types::ISO8601DateTime`](https://graphql-ruby.org/type_definitions/scalars) type for datetime fields

- Consider using [enums](https://graphql-ruby.org/type_definitions/enums.html) for categorical data
(e.g. Active Record or Postgres enums)

- Consider adding a custom [scalar](https://graphql-ruby.org/type_definitions/scalars.html#custom-scalars) type to underline the _meaning_ of the value (i.e. `URL` type instead of
just `String`). **NOTE:** add _general_ scalar types to `common-graphql` gem.

- Use `method:` and `hash_key:` options instead of defining methods (see [Field Resolution](https://graphql-ruby.org/fields/introduction#field-resolution)):

```ruby
# Bad
class SomeType < CoreBy::Schema::Object
  field :id, ID, null: false
  field :meta, MetadataType, null: true

  def id
    object.external_id
  end
end

class MetadataType < CoreBy::Schema::Object
  field :device, String, null: true

  def device
    object["device_id"]
  end
end

# Good
class SomeType < CoreBy::Schema::Object
  field :id, ID, null: false, method: :external_id
  field :meta, MetadataType, null: true
end

class MetadataType < CoreBy::Schema::Object
  field :device, String, null: true, hash_key: "device_id"
end
```

By default fields are accessible by an unauthenticated user. If you want to make some field is private, use `authenticate: true` option.

```ruby
field :logout, mutation: Mutations::Login, authenticate: true
```

Also, you can group such fields on a group:

```ruby
with_options authenticate: true do
  field :logout, mutation: Mutations::Login
  field :another_field
end
```

If you want authorize field by some user's attribute, you can use `user_checks` option.

```ruby
field :foo, String, null: false, user_checks: {completed: true}
```

The above field will check `current_user.completed?` method when authorizing an access.

- Use `AttachmentURLField` extension for Active Storage attachments:

```ruby
field :avatar_url, CoreBy::Types::URLString::Types::URLString, "URL of user's avatar", null: true do
  extension FieldExtensions::AttachmentURLField, variant: {enum: Enums::AvatarVariant, required: true}
end
```

This extension resolves the field and:
- preloads the required associations
- accepts a `variant` argument to allow fetching the required image variant.

The name of the attachment is resolved automatically from the field name
(`smth_url` -> `smth`).

You can specify the attachment name explicitly:

```ruby
field :avatar_url, CoreBy::Types::URLString::Types::URLString, "URL of user's avatar", null: true do
  extension FieldExtensions::AttachmentURLField, attachment: :avatar
end
```

## Mutations

### Naming / Structure

Organize mutations classes in a similar way we organize query objects or services:

```
app/
  graphql/
    <engine>/
      mutations/
        <resources>/
          <verb>(_<smth>).rb
```

The mutations MUST be named using the following scheme: `<verb><Resource>[<Smth>]`.

Consider an example:

```
mutations/
  profile/
    update_info.rb
    update_avatar.rb
    update_password.rb
```

**NOTE:** it's a best practice to make mutations as _specific_ as possible (unlike having single REST-like `updateSmth` mutation). Though, in the example above we have one _generic_ mutation–`updateProfileInfo`–which is assumed to handle multi-field input, 'cause adding a mutation per every simple model field seems like an overhead.

The above mutations names are `updateProfileInfo`, `updateProfileAvatar`, `updateProfilePassword`,
i.e. in your _mutation_ type:

```ruby
field :update_profile_info, mutation: Mutations::Profile::UpdateInfo
field :update_profile_avatar, mutation: Mutations::Profile::UpdateAvatar
field :update_profile_password, mutation: Mutations::Profile::UpdatePassword
```

## Inputs

- Use input object for every mutation accepting **more than one argument**

- Define input types right in the mutation classes if their not shared with other mutations

- Name input types using capitalized mutation name (**not class name**) + `Info`:

```ruby
module AuthBy
  module Mutations
    module Profile
      class UpdateInfo < CoreBy::Schema::Mutation
        class UpdateProfileInfoInput < Schema::Input
          argument :first_name, String, required: false
          argument :last_name, String, required: false
          argument :bio, String, required: false
        end

        field :input, UpdateProfileIntoInput
      end
    end
  end
end
```

## Outputs

- Use `ValidationErrors` (`CoreBy::Types::ValidationErrors`) type to return user input related errors (represented as `ActiveModel::Errors`):

```ruby
# some mutation
# ...
field :errors, ValidationErrors, null: true

def resolve(*)
  # ...
  if form.save
    {}
  else
    {errors: form.errors}
  end
end
```

Resources:
- [Designing GraphQL Mutations](https://blog.apollographql.com/designing-graphql-mutations-e09de826ed97)
