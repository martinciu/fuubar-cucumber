Gem::Specification.new do |s|
  s.name          = "fuubar-cucumber"
  s.version       = '0.0.20'
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Marcin Ciunelis", "Vasiliy Ermolovich"]
  s.email         = ["marcin.ciunelis@gmail.com", "younash@gmail.com"]
  s.homepage      = "https://github.com/martinciu/fuubar-cucumber"
  s.summary       = %q{the instafailing Cucumber progress bar formatter}
  s.description   = %q{the instafailing Cucumber progress bar formatter}
  s.licenses      = ["MIT"]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'cucumber', ["~> 1.3.0"]
  s.add_dependency 'ruby-progressbar', ["~> 1.2.0"]
end
