require 'rugged'

module Norp
  module Base

    def run branch: 'master', formatter: :text
      @repo = Rugged::Repository.new '.'

      files = get_file_diff_list branch: branch

      ap files
    end

    def get_file_diff_list(branch:)
      branch_ref = @repo.branches[branch]

      diff = @repo.index.diff branch_ref.log.last

      diff.find_similar!

      debugger

      diff.each_delta
        .select{ |d| [ :modified, :added, :renamed ].include? d.status }
        .map{ |d| Norp::Wrappers::File.new path: d.new_file[:path] }
    end

  end
end
