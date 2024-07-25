# README
This is a simple game-hints application that uses Sinatra to run dictionary searches. The supported games are in the `models` directory.

run server locally with
`ruby application.rb`

browser:
* http://localhost:4567/
* http://127.0.0.1:4567


## Resources
* Docs: https://sinatrarb.com/intro.html
* Helpers: https://www.sitepoint.com/sinatras-little-helpers/
* Extensions: https://sinatrarb.com/extensions.html

If you want to use gems like pry in development only, you need to wrap them in an env flag like:
```ruby
# application.rb

if settings.environment == :development
  require 'pry'
end

# or
require 'pry' if development?
```

### Sinatra Tutorials
* https://www.honeybadger.io/blog/building-a-sinatra-app-in-ruby/
* https://webapps-for-beginners.rubymonstas.org/sinatra/hello_world.html
* https://medium.com/@mcdowpm/how-to-build-a-sinatra-app-2ac89fd058a0

### Routing
* https://stackoverflow.com/questions/38574665/setting-root-route-in-sinatra

### Stylesheets
* https://stackoverflow.com/a/12341301/5009528

### Heroku
* https://blog.heroku.com/32_deploy_merb_sinatra_or_any_rack_app_to_heroku
* https://devcenter.heroku.com/articles/rack#sinatra
* https://medium.com/@isphinxs/deploying-a-sinatra-app-to-heroku-7944b024f77c
* https://puzzle-hints-0494e49572eb.herokuapp.com/
* https://git.heroku.com/puzzle-hints.git

### Deploying to Heroku
* run `heroku config:set RACK_ENV=production`
* ensure any development gems are inside of an `settings.environment == :development` in the `application.rb`
* add a Procfile with `web: bundle exec ruby application.rb -p $PORT`

# Testing
There are currently no tests for this application. When it is time to write tests, I will need to install rspec and include a Rakefile with test (and prod?) scripts.
