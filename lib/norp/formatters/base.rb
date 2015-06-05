module Norp
  module Formatters

    # @abstract Subclass and override {#get_output}
    class Base
      # @!attribute [r] files
      #   Array of Norp::Wrappers::File objects, representing all of the
      #   changes since the reference
      attr_reader :files

      def initialize(files:)
        @files = files
      end

      def get_output
        fail NotImplementedError
      end
    end

  end
end
