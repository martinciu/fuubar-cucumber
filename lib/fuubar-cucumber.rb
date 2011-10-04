require 'cucumber/formatter/fuubar'

# Extend Cucumber's builtin formats, so that this
# formatter can be used with --format fuubar
require 'cucumber/cli/options'

Cucumber::Cli::Options::BUILTIN_FORMATS["fuubar"] = [
  "Cucumber::Formatter::Fuubar",
  "The instafailing Cucumber progress bar formatter"
]