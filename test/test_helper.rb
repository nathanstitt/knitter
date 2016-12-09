require "minitest"
require "minitest/autorun"
require 'minitest/mock'
require 'spy/integration'
require 'pathname'

require_relative '../lib/knitter'


module HelperMethods
    FIXTURES_PATH =  Pathname.new(__FILE__).dirname.join('fixtures')
    def with_package
        yarn = Knitter::Yarn.new(FIXTURES_PATH)
        pkg  = yarn.package_file.read
        lock = yarn.directory.join('yarn.lock').read
        yarn.init unless yarn.valid?
        yield yarn
        yarn.package_file.write(pkg)
        yarn.directory.join('yarn.lock').write lock
    end
end

class MiniTest::Test


    include HelperMethods
    alias_method :run_without_around, :run
    def run(*args)
        if defined?(around)
            around { run_without_around(*args) }
        else
            run_without_around(*args)
        end
        self
    end
end
