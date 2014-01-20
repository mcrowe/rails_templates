remove_file 'README.rdoc'
create_file 'README.md', 'TODO'

gem 'thin'

gem_group :development, :test do
  gem 'rspec-rails'
  gem 'debugger'
end

gem_group :test do
  gem 'capybara'
  gem 'database_cleaner'
end

run 'bundle install'
generate 'rspec:install'

application 'config.generators.stylesheets = false'
application 'config.generators.javascripts = false'
application 'config.generators.helper = false'

git :init
append_file '.gitignore', 'config/database.yml'
run 'cp config/database.yml config/example_database.yml'
git add: '.', commit: "-m 'initial commit'"