require 'rugged'

require 'norp/wrappers/file'

module Norp
  module Wrappers
    class Git
      attr_accessor :repo, :files

      def initialize path: '.'
        @repo = Rugged::Repository.new '.'
      end

      # Returns an array of Norp::Wrappers::File object representing all the
      # changes since the commit sha or last commit in the given branch
      #
      # @param sha [String] commit sha or Rugged::Commit
      # @param branch [String] name of the branch to use as the reference
      #
      # @return [Array] filled with Norp::Wrappers::File objects
      def files_changed_since sha: nil, branch: nil
        if branch
          commit = branch_commit branch
        else
          commit = lookup_commit sha
        end

        diff = @repo.index.diff commit

        files_from_diff diff
      end

      def inspect
        "<Norp::Wrappers::Git:#{object_id} repo=#{@repo.path}>"
      end

      private

      # Look up the last commit for the given branch
      #
      # @return [Rugged::Commit]
      def branch_commit branch
        @repo.branches[branch].target
      end

      # @return [Rugged::Commit]
      def lookup_commit sha
        return sha if sha.kind_of? Rugged::Commit

        @repo.lookup sha
      end

      # Builds an array of files, and their line changes from a given diff
      # object
      #
      # @param diff [Rugged::Diff]
      #
      # @return [Array] array of Norp::Wrappers::File objects
      def files_from_diff diff
        files = []

        diff.each_patch
          .select{ |patch| [ :modified, :added, :renamed ].include? patch.delta.status }
          .each do |patch|
            file_path = patch.delta.new_file[:path]

            lines = patch.hunks.map do |hunk|
              hunk.lines
                .reject{ |line| [ :context, :deletion ].include? line.line_origin }
                .map{ |line| line.content }
            end.flatten

            files << Norp::Wrappers::File.new(path: file_path, lines: lines, patch: patch)
          end

        files
      end

    end
  end
end
