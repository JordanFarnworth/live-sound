require 'factory_girl_rails'
require_relative './support/json.rb'
require_relative './support/session.rb'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.before :suite do
    Delayed::Worker.delay_jobs = false
  end
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
