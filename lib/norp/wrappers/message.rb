module Norp
  module Wrappers

    class Message
      attr_accessor :body, :level, :line

      LEVELS = [ :info, :warning, :error ]

      def initialize body, level: :info, line: nil
        fail ArgumentError, "Level should be one of #{LEVELS.join ', '}" unless LEVELS.include? level

        @body, @level, @line = body, level, line
      end

      def inspect
        "<Norp::Wrappers::Message:#{object_id} level=#{@level}, line=#{@line}, body=#{@body}>"
      end

    end

  end
end
