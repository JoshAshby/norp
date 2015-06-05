module Norp

  class IgnoreFile
    # @param name [String] name/path of the ignore file
    #
    # @raises [ArgumentError] if the ignore file does not exist
    def initialize name: '.norpignore'
      @name = name

      fail ArgumentError, "ignore file doesn't exist" unless File.exist? @name

      @contents = File.open(@name).readlines
    end

    # Checks if a path is listed in the ignore file or not
    #
    # @param path [String]
    #
    # @return [Boolean]
    def contains? path
      @contents.any? do |line|
        File.fnmatch? line, path
      end
    end
  end

end
