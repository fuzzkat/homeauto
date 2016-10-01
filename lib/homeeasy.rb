require 'json'
require 'rest-client'
require File.dirname(__FILE__) + '/user_aware_rest_client'

class HomeEasy

	ROOT_URL = 'http://homeeasy/cgi-bin/'
	ALL_ROOM_ENDPOINT = 'allroomdevice.cgi'

  @rest_client

  def initialize username, password, rest_client=UserAwareRestClient.new(username, password, ROOT_URL, rest_client)
    @rest_client = rest_client
  end

  def rooms
    unless @rooms
      response = @rest_client.post(ROOT_URL + ALL_ROOM_ENDPOINT, { optype: 'select' })
      body = JSON.parse(response.body)
      @rooms = []
      body['room'].each do |room|
        @rooms << "A room"
      end
    end
    return @rooms
  end
end
