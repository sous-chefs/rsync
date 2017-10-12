require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.color = true               # Use color in STDOUT
  config.formatter = :documentation # Use the specified formatter
  config.log_level = :error         # Avoid deprecation notice SPAM
end

def mock_service_resource_providers(hints)
  allow(Chef::Platform::ServiceHelpers).to receive(:service_resource_providers).and_return(hints)
end
