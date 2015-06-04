require 'rugged'

module Norp
  module Base

    def run branch: 'master', formatter: :text
      @repo = Rugged::Repository.new '.'

      files = get_file_diff_list branch: branch

      ap files
    end

    def paths_from_diff diff
      diff.find_similar!

      diff.each_delta
        .select{ |delta| [ :modified, :added, :renamed ].include? delta.status }
        .map{ |delta| delta.new_file[:path] }
    end

    def get_file_diff_list(branch:)
      branch_ref = @repo.branches[branch]

      paths = []

      # Get all the commits that are different from the current working branch
      # and master and grab all the changed files...
      walker = Rugged::Walker.new @repo
      walker.sorting Rugged::SORT_TOPO | Rugged::SORT_REVERSE
      walker.push branch_ref.target
      walker.each do |commit|
        next if commit.parents.count != 1  # Skip if a merge commit since we don't care about those changes

        paths.concat paths_from_diff commit.parents[0].diff(commit)
      end

      paths.concat paths_from_diff @repo.index.diff # Make sure to include the diffs from staging too...

      paths.uniq.map{ |p| Norp::Wrappers::File.new path: p }
    end

  end
end

