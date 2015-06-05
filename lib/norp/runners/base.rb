module Norp
  module Runners

    # @abstract Subclass and override {#run!}
    class Base
      # @!attribute [rw] files
      #   Array of Norp::Wrappers::File objects, representing all of the
      #   changes since the reference
      attr_accessor :files

      def initialize(files:)
        @files = files
      end

      def run!
        fail NotImplementedError
      end
    end

  end
end
