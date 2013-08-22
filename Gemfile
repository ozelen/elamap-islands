source 'https://rubygems.org'

gem 'rails', '3.2.13'
gem "rails3-generators"
gem 'thin'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'


group :development, :test do
  gem 'sqlite3'
  gem 'rvm'
  gem 'pg'
  gem 'activerecord-postgresql-adapter'
  gem "nifty-generators"
end

group :production do
  gem 'taps'
  gem 'pg'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'yaml_db' # back up db
gem 'cancan'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem "therubyracer"
gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem "twitter-bootstrap-rails"
gem "breadcrumbs_on_rails"
gem "paperclip", "~> 3.0"

gem 'fog'

gem "authlogic"#, :git => "git://github.com/binarylogic/authlogic.git"

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
 gem 'unicorn'

# Deploy with Capistrano
 gem 'capistrano'

# To use debugger
# gem 'debugger'

gem "mocha", :group => :test

