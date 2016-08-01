source 'https://rubygems.org'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "paperclip", "~> 5.0.0"
gem 'react-rails', :github => 'reactjs/react-rails', :branch => 'master'
gem 'rails', '~> 5.0.0.beta1'
gem 'pg'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks', '~> 5.x'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'bcrypt', '~> 3.1.7'
gem 'geokit-rails'
gem 'clockwork', git: 'https://github.com/tomykaira/clockwork.git'
gem 'cancan'
gem 'bootstrap_form'
gem 'daemons'
gem 'delayed_job_active_record'
gem 'bootstrap-sass', '>= 3.2.0'
gem 'autoprefixer-rails'
gem 'will_paginate-bootstrap'
gem 'font-awesome-rails'
gem 'paranoia'
gem 'unicorn'
gem 'aws-sdk', '< 2.0'
gem "sentry-raven"
gem 'omniauth'
gem 'omniauth-facebook', '1.4.0'
gem 'redis', '~> 3.0'

group :development, :test do
  gem 'byebug'
  gem 'bullet'
  gem 'web-console', '~> 2.0'
  gem 'listen', '~> 3.0.5'
  gem 'factory_girl_rails'
  gem 'timecop'
  gem 'simplecov'
  gem 'pry-rails'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rspec-rails', '~> 3.0'
  gem 'database_cleaner'
  gem 'forgery'
  gem 'git_stats'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :production do
  gem 'rails_12factor'
end
