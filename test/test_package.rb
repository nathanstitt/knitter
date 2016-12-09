require_relative './test_helper'

class TestPackage < MiniTest::Test

    def around
        with_package do |yarn|
            @yarn = yarn
            yield
        end
    end

    def test_reads_from_package
        config = JSON.parse(@yarn.package_file.read)
        config['dependencies'] = {'foo' => "^1.2.3" }
        @yarn.package_file.write JSON.dump(config)
        package = Knitter::Package.new('foo', yarn: @yarn)
        assert package.installed?
        assert_equal '^1.2.3', package.version.to_s
        assert_equal :dependencies, package.dependency_type
    end

    def test_package_area
        package = Knitter::Package.new('foo', yarn: @yarn)
        package.dependency_type=:optional
        assert_equal :optional, package.dependency_type
        package.dependency_type=:development
        assert_equal :development, package.dependency_type
    end

end
