require 'norp/wrappers/message'

module Norp
  module Wrappers

    class File
      attr_accessor :path, :lines, :patch, :messages

      def initialize path:, lines: [], patch: nil
        @path, @lines, @patch = path, Array(lines), patch

        @messages = []
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

      def add_message body, level: :info, line: nil
        @messages << Norp::Wrappers::Message.new(body, level: level, line: line)
      end

      def inspect
        "<Norp::Wrappers::File:#{object_id} path=#{@path}, lines=\n#{@lines.join(' ')}, messages=#{@messages}, patch=#{@patch}>"
      end

    end

  end
end
