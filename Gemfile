source "https://rubygems.org"

# Specify your gem's dependencies in morfo.gemspec
gemspec

group :test, :development do
  gem "rspec", ">= 2.14", "< 4.0"
  gem "coveralls", require: false
  gem "simplecov"
  gem "rubinius-coverage", platform: :rbx
end

group :development do
  gem "guard"
  gem "guard-rspec"
  gem "pry"

  gem "rb-inotify", require: false
  gem "rb-fsevent", require: false
  gem "rb-fchange", require: false
end
