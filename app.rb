require "sinatra"

class App < Sinatra::Base
  get '/' do
    'Hello world!'
  end

  post '/jira' do
    puts request.inspect
  end
end
