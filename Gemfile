source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").strip

gem "puma"
gem "rake"
gem "rackup"
gem "sinatra"
# gem 'sinatra-activerecord'
gem "sinatra-contrib" # https://sinatrarb.com/contrib/multi_route.html
gem "emk-sinatra-url-for" # path helpers https://github.com/emk/sinatra-url-for/
# gem 'sinatra-static-assets'

group :development do
  gem "pry"
  # gem 'foreman'
  gem "standard"
  # gem 'sqlite3', '~> 1.3', '>= 1.3.11'
end

group :test do
  %w[rspec rspec-core rspec-expectations rspec-mocks rspec-support].each do |lib|
    gem lib, git: "https://github.com/rspec/#{lib}.git", branch: "main"
  end

  gem "rack-test"
end

group :production do
  # gem 'pg'
end
