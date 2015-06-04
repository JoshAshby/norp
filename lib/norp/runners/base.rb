module Norp
  module Runners

    class Base

      def initialize
      end

      def run
        fail NotImplementedError
      end

    end

  end
end
