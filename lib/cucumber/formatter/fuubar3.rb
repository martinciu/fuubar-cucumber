require 'cucumber/formatter/progress'
require 'ruby-progressbar'

module Cucumber
  module Formatter
    class Fuubar < Progress
      def initialize(config)
        super
        config.on_event :test_run_started, &method(:test_run_started)
      end

      def test_run_started(event)
        steps = event.test_cases.map(&:test_steps).flatten.reject(&method(:hook?))
        @progress_bar = ProgressBar.create(:format => ' %c/%C |%w>%i| %e ', :total => steps.count, :output => @io)
      end

      def on_test_step_finished(event)
        test_step = event.test_step
        result = event.result.with_filtered_backtrace(Cucumber::Formatter::BacktraceFilter)
        progress(result.to_sym) unless hook?(test_step)

        return if hook?(test_step)
        collect_snippet_data(test_step, result)
        @pending_step_matches << @matches[test_step.source] if result.pending?
        @failed_results << result if result.failed?
      end

      private

      COLORS = { :green =>  "\e[32m", :yellow => "\e[33m", :red => "\e[31m" }

      def state
        @state ||= :green
      end

      def progress(status)
        @state = :red if status == :failed
        with_colors(COLORS[state]) { @progress_bar.progress += 1 }
      end

      def with_colors(color, &block)
        @io.print color if colors_enabled?
        yield
        @io.print "\e[0m" if colors_enabled?
      end

      def colors_enabled?
        Cucumber::Term::ANSIColor.coloring?
      end
      
      def hook?(step)
        HookQueryVisitor.new(step).hook?
      end
    end
  end
end
