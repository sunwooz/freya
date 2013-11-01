# Pigeon

A minimal email link generator

## Installation

Add this line to your application's Gemfile:

    gem 'pigeon'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pigeon

## Usage

Create a yml file containing the bodies of your emails.

```yml
test:
    email1: This is a test email
```

Then you create a link to this email like this:

```ruby
mail_to Pigeon::Email.new(name:'test email', to: 'test@test.com', subject: 'test_subject).link, 'Email' 
```

You can access mail bodies using the `name` attribute separating nodes with white spaces.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
