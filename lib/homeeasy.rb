require 'json'
require 'rest-client'
require_relative 'user_aware_rest_client'

class HomeEasy

	ROOT_URL = 'http://homeeasy/cgi-bin/'
	ALL_ROOM_ENDPOINT = 'allroomdevice.cgi'
  DEVICE_CONTROL_ENDPOINT = 'devicecontrol.cgi'
  SCENE_CONTROL_ENDPOINT = 'scenoperation.cgi'

  @rest_client

  def initialize username, password, rest_client=UserAwareRestClient.new(username, password, ROOT_URL, RestClient)
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

  def scene scenid
    @rest_client.post(ROOT_URL + SCENE_CONTROL_ENDPOINT, { optype: 'scenon', scenid: scenid })
  end

end
