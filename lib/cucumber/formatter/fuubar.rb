require 'cucumber/formatter/console'
require 'cucumber/formatter/ansicolor'
require 'cucumber/formatter/io'
require 'ruby-progressbar'

module Cucumber
  module Formatter
    class Fuubar
      include Console
      include Io

      attr_reader :runtime
      alias_method :step_mother, :runtime

      def initialize(runtime, path_or_io, options)
        @runtime, @io, @options = runtime, ensure_io(path_or_io, "fuubar"), options
        @step_count = @issues_count = 0
      end

      def after_features(features)
        @state = :red if runtime.scenarios(:failed).any?
        @io.puts
        @io.puts
        print_summary(features)
      end

      def before_features(features)
        @step_count = features.step_count
        @progress_bar = ProgressBar.create(:format => ' %c/%C |%w>%i| %e ', :total => @step_count, :output => @io)
      end

      def before_background(background)
        @in_background = true
      end

      def after_background(background)
        @in_background = false
      end

      def after_step_result(keyword, step_match, multiline_arg, status, exception, source_indent, background, file_colon_line)
        return if @in_background || status == :skipped
        @state = :red if status == :failed
        if exception and [:failed, :undefined].include? status
          @io.print "\e[K" if colors_enabled?
          @issues_count += 1
          @io.puts
          @io.puts "#{@issues_count})"
          print_exception(exception, status, 2)
          @io.puts
          @io.flush
        end
        progress(status)
      end

      def before_examples(examples)
        @is_example = true
      end

      def after_examples(examples)
        @is_example = false
      end

      def before_table_row(table_row)
        if @is_example && table_row.is_a?(Cucumber::Ast::OutlineTable::ExampleRow) && table_row.scenario_outline && table_row.scenario_outline.instance_variable_get("@background").instance_variable_get("@steps")
          progress(:passed, table_row.scenario_outline.instance_variable_get("@background").instance_variable_get("@steps").count)
        end
      end

      def after_table_row(table_row)
        if @is_example && table_row.is_a?(Cucumber::Ast::OutlineTable::ExampleRow) && table_row.scenario_outline
          progress(:passed, table_row.scenario_outline.instance_variable_get("@steps").count)
        end
      end

      protected
        def state
          @state ||= :green
        end

        def print_summary(features)
          print_stats(features, @options)
          print_snippets(@options)
          print_passing_wip(@options)
        end

        COLORS = { :green =>  "\e[32m", :yellow => "\e[33m", :red => "\e[31m" }

        def progress(status = 'passed', count = 1)
          with_colors(COLORS[state]) do
            @progress_bar.progress += count
          end
        end

        def with_colors(color, &block)
          @io.print color if colors_enabled?
          yield
          @io.print "\e[0m" if colors_enabled?
        end

        def colors_enabled?
          Cucumber::Term::ANSIColor.coloring?
        end
    end
  end
end
