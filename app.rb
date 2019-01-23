require 'sinatra'
require 'sidekiq'
require_relative 'lib/workers/sound_worker.rb'

class App < Sinatra::Base
  get '/' do
    'Hello world!'
  end

  post '/jira' do
    payload = JSON.parse(request.body.read.to_s)
    puts request.inspect
    puts payload.inspect

    case payload['webhookEvent']
    when 'jira:issue_updated'
      status = payload['issue']['fields']['status']['name']
      changelog_items = payload['changelog']['items'].map {|i| i['toString']}
      team = payload['issue']['fields']['customfield_12012']['value']
    when 'sprint_started'
      sprint_started(payload['sprint']['name'])
    end
  end
      
  private

  def sprint_started(name)
    if /Atlas/.match(name)
      SoundWorker.perform_async(:sprint_started)
    end
  end

  def issue_updated(status, changelog_items, team)
    if status == 'Done' && changelog_items.include?('Done') && team == 'Atlas'
      SoundWorker.perform_async(:issue_done)
    end
  end
end
