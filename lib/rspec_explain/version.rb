module RSpecExplain
  VERSION = "0.0.2"
end

require_relative 'explain'

RSpec.configure do |config|
  config.extend RSpecExplain
end