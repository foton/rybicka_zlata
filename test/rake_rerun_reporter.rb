require "minitest/reporters"

module Minitest
  module Reporters
    class RakeRerunReporter < Minitest::Reporters::DefaultReporter

      def report
        super
      
        puts
      
        unless @fast_fail
          #print rerun commands
          failed_or_error_tests=(tests.select {|t| t.failure && !t.skipped? })

          if failed_or_error_tests.present?
            puts red("You can rerun failed/error test by commands (with optionally 'bundle exec' prefix):")

            failed_or_error_tests.each do |test|
              print_rerun_command(test)
            end
          end
        end
        
        #summary for all suite again
        puts
        print colored_for(suite_result, result_line)
        puts
        
      end  

      private

        def print_rerun_command(test)
          message = rerun_message_for(test)
          unless message.nil? || message.strip == ''
            puts
            puts colored_for(result(test), message)
          end
        end

        def rerun_message_for(test)
          file_path=location(test.failure).gsub(/(\:\d*)\z/,"")
          msg="rake test TEST=#{file_path} TESTOPTS=\"--name=#{test.name} -v\""
          if test.skipped?
            "Skipped: \n#{msg}"
          elsif test.error?
            "Error:\n#{msg}"
          else
            "Failure:\n#{msg}"
          end
        end

    end
  end
end
