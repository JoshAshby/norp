module Norp
  module Wrappers

    class File
      attr_accessor :path

      def initialize path:
        @path = path
      end

      def == other
        @path == other.path
      end

    end

  end
end
