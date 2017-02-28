# Knitter

[![Build Status](https://travis-ci.org/nathanstitt/knitter.svg?branch=master)](https://travis-ci.org/nathanstitt/knitter)

A lightweight Ruby Gem wrapper around the node package manager.  Allows checking installation status of and installing packages.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'knitter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install knitter

## Usage

```ruby
require 'knitter'

yarn = Knitter::Yarn.new('my-npm-project-directory')

# create a bare-bones 'package.json' and 'yarn.lock' file
yarn.init

# test with the infamous left-pad.
package = Knitter::Package.new('left-pad', yarn: yarn)

package.installed? # false

package.add

package.installed? # true
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nathanstitt/npm-wrapper.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
