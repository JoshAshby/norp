require 'rugged'

require 'norp/wrappers/file'

module Norp
  module Wrappers
    class Git
      attr_accessor :repo, :files

      def initialize path: '.'
        @repo = Rugged::Repository.new '.'
      end

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

      def branch_commit branch
        @repo.branches[branch].target
      end

      def lookup_commit sha
        return sha if sha.kind_of? Rugged::Commit

        @repo.lookup sha
      end

      def files_from_diff diff
        files = []

        diff.find_similar!

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
