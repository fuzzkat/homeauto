#!/usr/bin/env ruby

require './lib/homeeasy.rb'

homeeasy = HomeEasy.new(ENV["HOMEEASY_USER"], ENV["HOMEEASY_PASS"])
puts homeeasy.status

