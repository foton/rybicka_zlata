require "minitest/reporters"

module Minitest
  module Reporters
    class RakeProgressReporter < Minitest::Reporters::DefaultReporter

      def print_failure(test)
        binding.pry
        message = message_for(test)
        unless message.nil? || message.strip == ''
          puts
          puts colored_for(result(test), message)
        end
      end

    end
  end
end
