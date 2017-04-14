require_relative 'homeeasy'

class HomeeasyWorker
	include Sidekiq::Worker

  @@homeeasy = HomeEasy.new(ENV["HOMEEASY_USER"], ENV["HOMEEASY_PASS"])

	def perform(device_id, state)
    case state
    when 'on'
      @@homeeasy.on device_id
    when 'off'
      @@homeeasy.off device_id
    end
	end
end
