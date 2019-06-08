module FuubarCucumber
  def cucumber3?
    defined?(::Cucumber) && ::Cucumber::VERSION >= '3'
  end

  module_function :cucumber3?

  require "cucumber/formatter/fuubar#{cucumber3? ? '3' : ''}"

  # Extend Cucumber's builtin formats, so that this
  # formatter can be used with --format fuubar
  require 'cucumber/cli/main'

  Cucumber::Cli::Options::BUILTIN_FORMATS["fuubar"] = [
    "Cucumber::Formatter::Fuubar",
    "The instafailing Cucumber progress bar formatter"
  ]
end
