# Knitter

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

process = NPMWrapper::Process.new('my-npm-project-directory')

# create a bare-bones 'package.json' file
process.init

# test with the infamous left-pad.  Process is optional, it will default to Dir.pwd
package = NPMWrapper::Package.new('left-pad', process: process)

package.installed? # false

package.install

package.installed? # true
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nathanstitt/npm-wrapper.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
