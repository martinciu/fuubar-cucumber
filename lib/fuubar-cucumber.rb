require 'cucumber/formatter/progress'

module Cucumber
  module Formatter
    class Fuubar < Progress

      attr_reader :step_count, :finished_count

      def initialize(step_mother, path_or_io, options)
        @step_count = @finished_count = @step_number = @issues_count = 0
        super
      end

      def before_features(features)
        @step_count = get_step_count(features)
        @progress_bar = ProgressBar.new("  #{@step_count} steps", @step_count, @io)
        @progress_bar.bar_mark = '='
      end

      def after_features(features)
        @io.print COLORS[state]
        @progress_bar.finish
        @io.print "\e[0m"
        super
      end

      def after_step_result(keyword, step_match, multiline_arg, status, exception, source_indent, background)
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

        def progress(status)
          @io.print COLORS[state]
          @finished_count += 1
          @progress_bar.inc
          @progress_bar.instance_variable_set("@title", "  #{@finished_count}/#{@step_count}")
          @io.print "\e[0m"
        end

        def get_step_count(features)
          count = 0
          features = features.instance_variable_get("@features")
          features.each do |feature|
            #get background steps
            if feature.instance_variable_get("@background")
              background = feature.instance_variable_get("@background")
              background.init
              background_steps = background.instance_variable_get("@steps").instance_variable_get("@steps")
              count += background_steps.size
            end
            #get scenarios
            feature.instance_variable_get("@feature_elements").each do |scenario|
              scenario.init
              #get steps
              steps = scenario.instance_variable_get("@steps").instance_variable_get("@steps")
              count += steps.size

              #get example table
              examples = scenario.instance_variable_get("@examples_array")
              unless examples.nil?
                examples.each do |example|
                  example_matrix = example.instance_variable_get("@outline_table").instance_variable_get("@cell_matrix")
                  count += example_matrix.size
                end
              end

              #get multiline step tables
              steps.each do |step|
                multi_arg = step.instance_variable_get("@multiline_arg")
                next if multi_arg.nil?
                matrix = multi_arg.instance_variable_get("@cell_matrix")
                count += matrix.size unless matrix.nil?
              end
            end
          end
          return count
        end
    end
  end
end
