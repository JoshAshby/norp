require 'rugged'

require 'norp/wrappers/file'

module Norp
  module Wrappers
    class Git
      attr_accessor :repo

      def initialize path: '.'
        @repo = Rugged::Repository.new '.'
      end

      def files_changed_since commit: nil, branch: nil
        fail ArgumentError, "Need a branch name or commit hash to work" unless commit || branch

        if branch
          branch_ref = @repo.branches[branch]
          commit = branch_ref.target
        end

        commit = @repo.lookup(commit) if commit.kind_of? String

        paths = []

        walker = Rugged::Walker.new @repo

        # Rugged docs says this is optional, but really I have no clue what I'm
        # doing...
        walker.sorting Rugged::SORT_TOPO | Rugged::SORT_REVERSE

        # Hide anything under this commit, to ensure we're working only on the
        # commits we care about and not the whole damn repo
        walker.hide commit

        walker.each do |commit|
          # Skip if a merge commit since we don't care about those changes
          next if commit.parents.count != 1

          paths.concat paths_from_diff commit.parents[0].diff(commit)
        end

        # Make sure to include the diffs from staging too...
        paths.concat paths_from_diff @repo.index.diff

        paths.uniq.map{ |p| Norp::Wrappers::File.new path: p }
      end

      private

      def paths_from_diff diff
        diff.find_similar!

        diff.each_delta
          .select{ |delta| [ :modified, :added, :renamed ].include? delta.status }
          .map{ |delta| delta.new_file[:path] }
      end

    end
  end
end
