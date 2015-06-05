require 'norp/wrappers/git'
require 'norp/formatters/base'
require 'norp/runners/base'

module Norp
  module Base

    def run formatter:, branch: 'master', runners: []
      @repo = Norp::Wrappers::Git.new path: '.'

      files = @repo.files_changed_since(branch: branch)
        .select{ |file| %w| .rb |.include? file.ext }

      runners.each do |runner|
        runner.new(files: files).run!
      end

      formatter.new(files: files).get_output
    end

  end
end

