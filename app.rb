require 'base64'
require 'sinatra'
require 'sidekiq'
require_relative 'lib/workers/sound_worker.rb'

class App < Sinatra::Base
  get '/' do
    'Hello world!'
  end

  post '/jira' do
    payload = JSON.parse(request.body.read.to_s)

    case payload['webhookEvent']
    when 'jira:issue_updated'
      status = payload['issue']['fields']['status']['name']
      changelog_items = payload['changelog']['items'].map {|i| i['toString']}
      team = payload['issue']['fields']['customfield_12012']
      if team
        issue_updated(status, changelog_items, team['value'])
      end
    when 'sprint_started'
      sprint_started(payload['sprint']['name'])
    end
  end

  post '/heroku' do
    payload = JSON.parse(request.body.read.to_s)
    puts request.inspect
    puts payload.inspect
  end
      
  private

  def issue_updated(status, changelog_items, team)
    if status == 'Done' && changelog_items.include?('Done') && team == 'Atlas'
      SoundWorker.perform_async(:issue_done)
    end
  end

  def sprint_started(name)
    if /Atlas/.match(name)
      SoundWorker.perform_async(:sprint_started)
    end
  end

  def valid_signature?(request)
    calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(
      OpenSSL::Digest.new('sha256'),
      ENV['HEROKU_WEBHOOK_SECRET'],
      request.raw_post
    )).strip
    heroku_hmac = request.headers['Heroku-Webhook-Hmac-SHA256']

    heroku_hmac && Rack::Utils.secure_compare(calculated_hmac, heroku_hmac)
  end
end
