require 'rugged'

module Otnorp
  module Base

    def run branch: 'master', formatter: :text
      @repo = Rugged::Repository.new '.'

      files = get_file_list branch: branch

      ap files
    end

    def get_file_list(branch:)
      debugger
      branch_ref = @repo.branches[branch].log.last

      diff = @repo.index.diff branch_ref.log.last

      diff.deltas.map{ |d| d.new_file[:path] }
    end

  end
end
