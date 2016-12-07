require_relative './test_helper'

class TestPackage < MiniTest::Test

    def around
        with_package do |process|
            @process = process
            yield
        end
    end

    def test_reads_from_package
        config = JSON.parse(@process.package_file.read)
        config['dependencies'] = {'foo': "^1.2.3" }
        @process.package_file.write JSON.dump(config)
        package = Knitter::Package.new('foo', process: @process)
        assert package.installed?
        assert_equal '^1.2.3', package.version.to_s
        assert_equal :dependencies, package.dependency_type
    end

    def test_package_area
        package = Knitter::Package.new('foo', process: @process)
        package.dependency_type=:optional
        assert_equal :optional, package.dependency_type
        package.dependency_type=:development
        assert_equal :development, package.dependency_type
    end


end
