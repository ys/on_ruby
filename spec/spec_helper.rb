ENV["RAILS_ENV"]    ||= 'test'
ENV["SECRET_TOKEN"] ||= 'SECRET_TOKEN_TEST_b7c7374eb0285b87c0c1c61c2c5401b9f92dd59209713801743202c'

require 'coveralls'
Coveralls.wear!('rails')

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :mocha
  config.use_transactional_fixtures = true
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.before do
    I18n.locale = :de
    Whitelabel.label = Whitelabel.labels.first
  end

  config.before(:each, type: :request) do
    host! "hamburg.onruby.dev"
  end

  config.before(:each, type: :controller) do
    set_subdomain
  end

  config.include RequestHelper, type: :controller
  config.include CachingHelper, type: :request
  config.include KaminariHelper
  config.include FactoryGirl::Syntax::Methods
end
