# TeihitsuTrainingCli

Teihitsu Training CLI is a simple quiz application based on CLI. It enables us to solve a huge amount of [Kanji Teihitsu][kanjiteihitsu-homepage] questions in numerical order rather than randomly.

[kanjiteihitsu-homepage]: https://hagunn2525.wixsite.com/kanji-teihitsu

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'teihitsu_training_cli'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install teihitsu_training_cli

## Usage

    cd teihitsu-training-cli
    trng

### Options
To specify the item you want to start:

    -start[-s]=<index>

if you want to know more options:

    thor help trng:onyomi

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake ` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yudukikun5120/teihitsu_training_cli. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/yudukikun5120/teihitsu_training_cli/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the TeihitsuTrainingCli project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/yudukikun5120/teihitsu_training_cli/blob/main/CODE_OF_CONDUCT.md).
