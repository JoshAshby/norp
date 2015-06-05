module Norp
  module Runners

    class Base
      attr_accessor :files

      def initialize files:
        @files = files
      end

      def run!
        fail NotImplementedError
      end
    end

  end
end
