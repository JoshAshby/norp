require 'norp/wrappers/git'

require 'norp/ignore_file'

require 'norp/formatters/base'
require 'norp/runners/base'

module Norp
  module Base

    # Runs the given runners against the specified branch and returns the
    # messages in the given format
    #
    # @param formatter [Norp::Formatters::Base]
    # @param branch [String] name of the branch to diff against
    # @param runners [Array] array of #Norp::Runners::Base
    # @param ignore_file [String] name/path of the ignore file to use
    #
    # @return [Object] output of the specified formatter
    def run formatter:, branch: 'master', runners: [], ignore_file: '.norpignore'
      @repo = Norp::Wrappers::Git.new path: '.'

      files = @repo.files_changed_since(branch: branch)
        .select{ |file| %w| .rb .rake .thor |.include? file.ext }

      if ignore_file
        ignore_file = Norp::IgnoreFile.new name: ignore_file
        files.reject!{ |file| ignore_file.contains? file.path }
      end

      Array(runners).each do |runner|
        runner.new(files: files).run!
      end

      formatter.new(files: files).get_output
    end

  end
end
