require "simplecov"
require "coveralls"

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter "spec"
end

require "rspec"
require "morfo"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
