+ TODO make changelog path and CHANGELOG file configurable

# changelog-rb

For project that uses feature branches and merge requests, it is common that the `CHANGELOG.md` will have conflicts. In order to prevent that, it is better to manage changelog items in a separate folder (`./changelog`) and generate the `CHANGELOG.md` during release.

This gem defines a bunch of commands to simplify the management of changelog items in `./changelog`.

The `CHANGELOG.md` generated will follow the amazing [keepachangelog](http://keepachangelog.com/en/1.0.0/) format.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'changelog-rb'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install changelog-rb

## Folder Structure

```
changelog
├── 0.1.1
│   ├── fixed_something.yml
│   └── tag.yml
├── 0.1.0
│   ├── added_something.yml
│   ├── changed_something.yml
│   └── tag.yml
└── unreleased
    ├── added_something.yml
    ├── changed_something.yml
    └── removed_something.yml
```

All the pending/unreleased changelog items should be in the `unreleased` folder. Once you release a new version, the corresponding changelog items in `unreleased` should be moved over to `[RELEASE VERSION]` folder.

The `tag.yml` in release folder is for recording the date of release.

## Usage

There are a bunch of commands helping you to manage the changelog items. They are base on the awesome library [thor](https://github.com/erikhuda/thor) so you can always check all the command options by running `changelog help [COMMAND]`.

### `setup`

Set up the basic folder structure.

```
$ changelog setup
```

### `add`

Add a changelog item.

| option| desc | detail |
|-------|------|--------|
| `-t` | Type of changes (one of the following `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`) | If not specified, it will try to derive it from the first word of the title |
| `-u` | Author | If not specified, it will be $USER |
| `-g` | From git commit comment | *Magic*. Get the git commit comment as changelog title. Please try to use it with `gitmoji`. |

```bash
$ changelog add "Changed something"
# type: Changed
# title: Changed something
# user: someone

$ changelog add "Support something" -t Changed
# type: Changed
# title: Support something
# user: someone

$ git commit -m "Fixed something"
$ changelog add -g
# type: Fixed
# title: Fixed something
# user: someone

$ gitmoji
$ changelog add -g
# type: Added
# title: ✨Added something
# user: someone

```

### `tag`

Move `unreleased` changelog items to the `version` given and tag today as release date.

```bash
$ changelog tag 0.1.0
```

### `show`

Show changelog of (`unreleased` and `latest` version) or `specific` version

```bash
$ changelog show
$ changelog show 0.1.0
```

### `untag`

Move the changelog items in `version` back to `unreleased` and clean it up.

```bash
$ changelog untag 0.1.0
```

### `print`

Generate `CHANGELOG.md` from `./changelog`

```bash
$ changelog print
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pinglamb/changelog-rb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
