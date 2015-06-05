module Norp
  module Formatters

    class Bare < Norp::Formatters::Base
      def get_output
        messages = []

        @files.each do |file|
          messages << "File: #{file.path}"
          file.messages.map{ |msg| "#{ msg.level }: #{ msg.body }" }.each{ |msg| messages << msg }
        end

        messages.join "\n"
      end
    end

  end
end
