require_relative './test_helper'

class TestProcess < MiniTest::Test

    def left_pad
        package = Knitter::Package.new('left-pad')
        package.version = '~1.1'
        package.dependency_type = :development
        package
    end

    def test_init
        with_package do |process|
            assert process.ok?
        end
    end

    def test_add_args
        with_package do |process|
            spy = Spy.on(process, :execute)
            process.add(left_pad)
            assert spy.has_been_called_with?(
                       "add", "left-pad@~1.1", '--dev'
                   )
        end
    end

    def test_add_for_reals
        with_package do |process|
            process.add(left_pad)
            assert process.ok?
            assert_includes(process.stdout, "Saved 1 new dependency")
        end
    end

end
