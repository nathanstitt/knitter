require "minitest"
require "minitest/autorun"
require 'minitest/mock'
require 'spy' #/integration'

require_relative '../lib/knitter'

module HelperMethods
    def with_package
        Dir.mktmpdir do |dir|
            process = Knitter::Process.new(dir)
            process.init
            yield process
        end
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
