module Norp
  module Formatters

    class Base
      attr_accessor :files

      def initialize files:
        @files = files
      end

      def get_output
        fail NotImplementedError
      end
    end

  end
end
