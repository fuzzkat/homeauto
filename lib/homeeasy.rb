require 'json'
require 'rest-client'
require File.dirname(__FILE__) + '/user_aware_rest_client'
require File.dirname(__FILE__) + '/room'
require File.dirname(__FILE__) + '/room_factory'

class HomeEasy

	ROOT_URL = 'http://homeeasy/cgi-bin/'
	ALL_ROOM_ENDPOINT = 'allroomdevice.cgi'
  DEVICE_CONTROL_ENDPOINT = 'devicecontrol.cgi'

  @rest_client

  def initialize username, password, rest_client=UserAwareRestClient.new(username, password, ROOT_URL, RestClient), room_factory=RoomFactory.new
    @rest_client = rest_client
  end

  def rooms
    @rest_client.post(ROOT_URL + ALL_ROOM_ENDPOINT, { optype: 'select' })
  end

  def on devid
    @rest_client.post(ROOT_URL + DEVICE_CONTROL_ENDPOINT, { optype: 'singledev', devtype: 'switch', controltype: 'on', devid: devid })
  end

  def off devid
    @rest_client.post(ROOT_URL + DEVICE_CONTROL_ENDPOINT, { optype: 'singledev', devtype: 'switch', controltype: 'off', devid: devid })
  end

end
