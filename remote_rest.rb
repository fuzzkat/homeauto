require 'sinatra'
require File.dirname(__FILE__) + '/lib/homeeasy'

homeeasy = HomeEasy.new(ENV["HOMEEASY_USER"], ENV["HOMEEASY_PASS"])

configure do
  set :bind, '192.168.0.8'
end

get '/rooms' do
  content_type :json
  response = homeeasy.rooms
  [response.code, response.body]
end

get '/devices/:devid/on' do
  content_type :json
  response = homeeasy.on params['devid']
end

get '/devices/:devid/off' do
  content_type :json
  response = homeeasy.off params['devid']
end
