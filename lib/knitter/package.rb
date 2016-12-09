require 'json'
require_relative 'package_version'

module Knitter
    class Package
        PackageConfig = Struct.new(:area, :version)

        attr_reader :name, :dependency_type

        attr_writer :yarn

        def initialize(name, yarn: nil)
            @name = name
            @yarn = yarn
        end

        def version
            @version ||= PackageVersion.new(config.version)
        end

        def version=(ver)
            @version = PackageVersion.new(ver)
        end

        def dependency_type=(type)
            @dependency_type = type
        end

        def dependency_type
            @dependency_type ||= Yarn::PACKAGE_AREAS.invert[config.area]
        end

        def installed?
            !config.area.nil?
        end

        def add
            yarn.add(self)
            @config = nil
        end

        def config
            @config ||= read_config
        end

        protected

        def yarn
            @yarn ||= Yarn.new(Dir.pwd)
        end

        def read_config
            config = PackageConfig.new
            json = yarn.package_file_contents
            %w{dependencies devDependencies optionalDependencies}.each do | part_name |
                part = json[part_name]
                next unless part && (version = part[@name])
                config.area = part_name
                config.version = version
            end
            config
        end

    end
end
