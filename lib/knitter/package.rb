require 'json'
require_relative 'package_version'

module Knitter
    class Package
        PackageConfig = Struct.new(:area, :version)

        attr_reader :name, :dependency_type

        attr_writer :process

        def initialize(name, process: nil)
            @name = name
            @process = process
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
            @dependency_type || (
                case config.area
                when 'optionalDependencies' then :optional
                when 'devDependencies'      then :development
                when 'peerDependencies'     then :peer
                else
                    :dependencies
                end
            )
        end

        def installed?
            !config.nil?
        end

        def add
            process.add(self)
            @config = nil
        end

        def config
            @config ||= read_config
        end

        def valid?
            process.package_file.exist? && config
        end

        protected

        def parse_package_file
            JSON.parse(process.package_file.read)
        end

        def process
            @process ||= Process.new(Dir.pwd)
        end

        def read_config
            config = PackageConfig.new
            package = parse_package_file
            %w{dependencies devDependencies optionalDependencies}.each do | part_name |
                part = package[part_name]
                next unless part && (version = part[@name])
                config.area = part_name
                config.version = version
            end
            config
        end

    end
end
