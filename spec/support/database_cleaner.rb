require 'capybara/rspec'

RSpec.configure do |config|

  DatabaseCleaner.allow_remote_database_url = true
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
    puts "before"
  end

  config.after(:each) do
    DatabaseCleaner.clean
    puts "after"
  end


end
