require_relative './test_helper'

class TestYarn < MiniTest::Test

    def left_pad
        package = Knitter::Package.new('left-pad')
        package.version = '~1.1'
        package.dependency_type = :development
        package
    end

    def test_init
        with_package do |yarn|
            assert yarn.valid?
        end
    end

    def test_add_args
        with_package do |yarn|
            spy = Spy.on(yarn, :execute)
            yarn.add(left_pad)
            assert spy.has_been_called_with?('add', 'left-pad@~1.1', '--dev')
        end
    end

    def test_add_for_reals
        with_package do |yarn|
            assert_equal 9, yarn.packages.to_a.length
            yarn.add(left_pad)
            assert yarn.ok?
            assert_includes(yarn.stdout, "success")
            assert_equal 10, yarn.packages.to_a.length
        end
    end

    def test_iteration
        with_package do |yarn|
            assert_equal 9, yarn.packages.to_a.length
            qs = yarn.packages.find{|pkg| pkg.name == 'qs' }
            assert qs
            assert_equal '6.3.0', qs.version.to_s
            assert_equal :peer, qs.dependency_type
        end
    end

end
