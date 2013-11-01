## 0.0.21 ## (November 2, 2013)
  * Fix `uninitialized constant Cucumber::RbSupport::RbLanguage::LanguageSupport` error when `cucumber`
  gem is not in Gemfile (by [@nashby](https://github.com/nashby))
  * Update ruby-progressbar depedency to `~> 1.2.0` (by [@jaredmoody](https://github.com/jaredmoody))

## 0.0.20 ##

### enhancements
  * Update cucumber depedency to `~> 1.3.0` (by [@nashby](https://github.com/nashby))

## 0.0.19 (March 9, 2013) ##

### bug fix
  * Make compatible with Cucumber 1.2.3's rename of step_mother to runtime (by [@amarshall](https://github.com/amarshall))

## 0.0.18 (August 22, 2012) ##

### bug fix
  * Update ruby-progressbar to 1.0.0 (fixes ruby-progress bar bugs) (by [@nashby](https://github.com/nashby))
  * Don't duplicate final progress bar output (7a2aeea) (by [@nashby](https://github.com/nashby))

### enhancements
  * Add ability to disable color with cucumber's `--color` option. #22 (by [@hron](https://github.com/hron))

## 0.0.17 (July 31, 2012) ##

### bug fix
  * Update ruby-progressbar to 0.11 (fixes bug with time mocking) (by [@betelgeuse](https://github.com/betelgeuse))

## 0.0.16 (July 20, 2012) ##

### bug fix
  * Conform to Cucumber 1.2.0 formatter API change (by [@iain](https://github.com/iain))
  * Reflect failures that coming from After callbacks (closes #10) (by [@nashby](https://github.com/nashby))
