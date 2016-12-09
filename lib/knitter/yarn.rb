require 'mixlib/shellout'
require 'forwardable'

module Knitter
    class Yarn

        PACKAGE_AREAS = {
            dev: 'devDependencies',
            peer: 'peerDependencies',
            optional: 'optionalDependencies',
            dependencies: 'dependencies'
        }

        extend ::Forwardable
        def_delegators :@sh, :stderr, :stdout

        attr_reader :directory

        def initialize(directory)
            @directory = Pathname.new(directory)
        end

        def init
            execute('init', '--yes')
        end

        def ok?
            @sh && @sh.status.exitstatus == 0
        end

        def add(package)
            name = package.name
            unless package.version.latest?
                name << '@' << package.version.to_s
            end
            execute(
                *['add', name, package_save_as_flag(package)].compact
            )
        end

        def package_file
            @directory.join "package.json"
        end

        def packages
            json = package_file_contents
            Enumerator.new do | enum |
                PACKAGE_AREAS.each do | type, area |
                    (json[area] || []).each do | package, version |
                        package = Package.new(package, yarn: self)
                        package.version = version
                        package.dependency_type = type
                        enum << package
                    end
                end
            end
        end

        def package_file_contents
            JSON.parse(package_file.read)
        end

        def valid?
            package_file_contents
        end

        protected

        def package_save_as_flag(package)
            case package.dependency_type
            when :peer        then '--peer'
            when :optional    then '--optional'
            when :development then '--dev'
            end
        end

        def execute(cmd, *args)
            @sh = Mixlib::ShellOut.new(
                "yarn", cmd, *args,
                cwd: @directory.to_s
            )
            @sh.run_command
        end
    end
end
