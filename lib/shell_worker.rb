class ShellWorker
	include Sidekiq::Worker

	def perform(device_name, state)
    `/var/lib/mythtv/bin/alexa_#{device_name}_#{state}`
	end
end
