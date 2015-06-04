require 'norp/wrappers/git'

module Norp
  module Base

    def run branch: 'master', formatter: :text
      @repo = Norp::Git.new path: '.'

      files = @repo.files_changed_since branch: branch
      files.select!{ |f| %w| .rb |.include? f.ext }

      files
    end

  end
end

