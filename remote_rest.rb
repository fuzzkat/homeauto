#!/usr/bin/env ruby

require 'sinatra'
require File.dirname(__FILE__) + '/lib/homeeasy'

homeeasy = HomeEasy.new(ENV["HOMEEASY_USER"], ENV["HOMEEASY_PASS"])

configure do
  set :bind, '192.168.0.9'
  set :port, '7770'
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

get '/mythtv/on' do
  `/var/lib/mythtv/bin/alexa_mythtv_on`
end

get '/mythtv/off' do
  `/var/lib/mythtv/bin/alexa_mythtv_off`
end

