module Norp
  module Wrappers

    class Message
      # @!attribute [rw] body
      #   Text of the message
      # @!attribute [rw] level
      #   see #LEVELS
      # @!attribute [rw] line
      #   Line number the message is for
      # @!attribute [rw] source
      #   Where did this message originate from? Most often a runners name
      attr_accessor :body, :level, :line, :source

      LEVELS = [ :info, :warning, :error ]

      def initialize body, level: :info, line: nil, source: nil
        fail ArgumentError, "Level should be one of #{LEVELS.join ', '}" unless LEVELS.include? level

        @body, @level, @line, @source = body, level, line, source
      end

      def inspect
        "<Norp::Wrappers::Message:#{object_id} level=#{@level}, line=#{@line}, source=#{@source}, body=#{@body}>"
      end

    end

  end
end
