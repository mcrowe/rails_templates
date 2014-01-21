remove_file "README.rdoc"
create_file "README.md", "TODO"

gem 'thin'

gem_group :development, :test do
  gem "rspec-rails"
  gem 'debugger'
end

gem_group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
end

run "bundle install"

# Setup generators.
application 'config.generators.helper = false'
application 'config.generators.javascripts = false'
application 'config.generators.stylesheets = false'

# Setup Rspec.
remove_dir 'test'
generate "rspec:install"

# Setup Capybara.
inject_into_file 'spec/spec_helper.rb', after: "require 'rspec/autorun'\n" do <<-'RUBY'
  require 'capybara/rspec'
RUBY
end

# Setup Database Cleaner.
gsub_file 'spec/spec_helper.rb', 'config.use_transactional_fixtures = true', <<-'RUBY'
config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
RUBY

# Hide database.yml from git repository.
append_file ".gitignore", "config/database.yml"
run "cp config/database.yml config/example_database.yml"

# Intialize a git repository.
git :init
git add: ".", commit: "-m 'initial commit'"