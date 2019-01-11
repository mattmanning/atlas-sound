require "sinatra"

class App < Sinatra::Base
  get '/' do
    'Hello world!'
  end

  post '/jira' do
    payload = JSON.parse(request.body.read.to_s)
    puts request.inspect
    puts payload.inspect
  end
end
