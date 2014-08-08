# Freya

Tool to build mailto links using static email bodies pulled from a YAML config file.

## Installation

Add this line to your application's Gemfile:

    gem 'freya'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install freya

## Usage

Create an email.yml file containing the bodies of your emails.

```yml
test:
    email: This is a test email
```

Then you create a link to this email like this:

```ruby
mail_to Freya::Email.new(name:'test.email', to: 'test@test.com', subject: 'test_subject).link, 'Email'
```

You can access mail bodies using the `name` attribute separating nodes with points.

You can also create your own email class and use `base_cc` and `base_bcc` to provide emails that have to be added to every cc and bcc of that subtype
For example:

```ruby
class TeamMemberEmail < Freya::Email
  def subject
    'Team email'
  end

  def name
    'team.email'
  end

  def base_cc
    ['base-email@email.com']
  end
end
```

If you want to create gmail links just use the `Freya::Gmail` class instead of the `Freya::Email` one.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
