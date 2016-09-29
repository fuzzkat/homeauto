require 'json'
require 'rest-client'

class HomeEasy

  LOGIN_ENDPOINT = 'http://homeeasy/cgi-bin/uservalid.cgi'

	@session = nil

  def initialize username, password, rest_client=RestClient
    response = rest_client.post(LOGIN_ENDPOINT, { UserName: username, UserPassword: password })
    body = JSON.parse(response.body)
    if body["sessvalid"] == '100' &&
       body["result"] == '200' &&
       body["session"] != nil
			@session = body['session']
		end
  end

  def status
		if @session
      :connected
    else
      :failed
    end
  end

end
