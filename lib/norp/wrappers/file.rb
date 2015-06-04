module Norp
  module Wrappers

    class File
      attr_accessor :path, :commits

      def initialize path:, commits: []
        @path, @commits = path, Array(commits)
      end

      def contents
        # This is probably a really bad idea for larger files...
        @file ||= ::File.read @path
      end

      def == other
        @path == other.path
      end

      def <=> other
        @path <=> other.path
      end

      def ext
        @ext ||= ::File.extname @path
      end

    end

  end
end
