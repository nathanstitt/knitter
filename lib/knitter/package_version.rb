module Knitter
    class PackageVersion


        def initialize(version)
            @version = version
        end

        def to_s
            @version.to_s
        end

        def latest?
            @version == :latest
        end
    end
end
