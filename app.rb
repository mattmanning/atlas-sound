require "sinatra"

get '/' do
  'Hello world!'
end

post '/jira' do
  puts request.inspect
end
