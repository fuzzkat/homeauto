require 'sinatra/base'
require 'sidekiq/web'

require_relative 'lib/homeeasy'
require_relative 'lib/homeeasy_worker'
require_relative 'lib/shell_worker'

class App < Sinatra::Base
  homeeasy = HomeEasy.new(ENV["HOMEEASY_USER"], ENV["HOMEEASY_PASS"])

  GOOD_RESPONSE = '{ "result": "200" }'

	get '/' do
		stats = Sidekiq::Stats.new
		workers = Sidekiq::Workers.new
		"
    <h1>Home Automation Router</h1>
    <h2>Queue Status</h2>
		<p>Processed: #{stats.processed}</p>
		<p>In Progress: #{workers.size}</p>
		<p>Enqueued: #{stats.enqueued}</p>
		<p><a href='/'>Refresh</a></p>
		<p><a href='/sidekiq'>Dashboard</a></p>
		"
	end

  get '/rooms' do
    content_type :json
    response = homeeasy.rooms
    [response.code, response.body]
  end

  get '/devices/:devid/on' do
    content_type :json
    HomeeasyWorker.perform_async(params['devid'], 'on')
    GOOD_RESPONSE
  end

  get '/devices/:devid/off' do
    content_type :json
    HomeeasyWorker.perform_async(params['devid'], 'off')
    GOOD_RESPONSE
  end

  get '/scenes/:scenid' do
    content_type :json
    HomeeasyWorker.perform_async(params['scenid'], 'scene')
    GOOD_RESPONSE
  end

  get '/mythtv/on' do
    ShellWorker.perform_async('mythtv', 'on')
    GOOD_RESPONSE
  end

  get '/mythtv/off' do
    ShellWorker.perform_async('mythtv', 'off')
    GOOD_RESPONSE
  end
end
