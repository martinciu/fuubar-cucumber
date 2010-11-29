require 'cucumber/formatter/progress'

module Cucumber
  module Formatter
    class Fuubar < Progress

      def initialize(step_mother, path_or_io, options)
        @step_count = @finished_count = @issues_count = 0
        @in_background = false
        @is_example = false
        super
      end

      def before_features(features)
        @step_count = get_step_count(features)
        @progress_bar = ProgressBar.new("  #{@step_count} steps", @step_count, @io)
        @progress_bar.bar_mark = '='
      end

      def before_background(background)
        @in_background = true
      end

      def after_background(background)
        @in_background = false
      end

      def after_features(features)
        @io.print COLORS[state]
        @progress_bar.finish
        @io.print "\e[0m"
        super
      end

      def after_step_result(keyword, step_match, multiline_arg, status, exception, source_indent, background)
        return if @in_background || status == :skipped
        @state = :red if status == :failed
        if [:failed, :undefined].include? status
          @io.print "\e[K"
          @issues_count += 1
          @io.puts
          @io.puts "#{@issues_count})"
          print_exception(exception, status, 2)
          @io.puts
          @io.flush
        end
        super
      end
      
      def before_examples(examples)
        @is_example = true
      end
      
      def after_exaples(examples)
        @is_example = false
      end
      
      def before_table_row(table_row)
        if @is_example && table_row.scenario_outline
          progress('passed', table_row.scenario_outline.instance_variable_get("@background").instance_variable_get("@steps").count)
        end
      end
      
      def after_table_row(table_row)
        if @is_example && table_row.scenario_outline
          progress('passed', table_row.scenario_outline.instance_variable_get("@steps").count)
        end
      end
      
      def table_cell_value(value, status)
        # return unless @outline_table
        # p "c #{value} - #{status}"
        # status ||= @status
        # progress(status) unless table_header_cell?(status)
      end

      protected

        def state
          @state ||= :green
        end

        def print_summary(features)
          print_stats(features, @options.custom_profiles)
          print_snippets(@options)
          print_passing_wip(@options)
        end

        CHARS = {
          :passed    => '.',
          :failed    => 'F',
          :undefined => 'U',
          :pending   => 'P',
          :skipped   => '-'
        }

        COLORS = { :green =>  "\e[32m", :yellow => "\e[33m", :red => "\e[31m" }

        def progress(status = 'passed', count = 1)
          @io.print COLORS[state]
          @finished_count += count
          @progress_bar.inc(count)
          @progress_bar.instance_variable_set("@title", "  #{@finished_count}/#{@step_count}")
          @io.print "\e[0m"
        end

        def get_step_count(features)
          count = 0
          features = features.instance_variable_get("@features")
          features.each do |feature|
            if feature.instance_variable_get("@background")
              background = feature.instance_variable_get("@background")
              background.init
              background_steps = background.instance_variable_get("@steps").instance_variable_get("@steps")
            end
            feature.instance_variable_get("@feature_elements").each do |scenario|
              scenario.init
              steps = scenario.instance_variable_get("@steps").instance_variable_get("@steps")
              scenario_size = steps.size
              if background_steps && scenario.is_a?(Cucumber::Ast::ScenarioOutline)
                background_size = background_steps.size
              end
              examples = scenario.instance_variable_get("@examples_array")
              if examples
                examples.each do |example|
                  example_matrix = example.instance_variable_get("@outline_table").instance_variable_get("@cell_matrix")
                  count += (scenario_size + background_size)*(example_matrix.size - 1)
                end
              else
                count += scenario_size
              end
            end
          end
          return count
        end
    end
  end
end
