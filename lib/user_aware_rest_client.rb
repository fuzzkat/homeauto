require 'json'

class UserAwareRestClient

  LOGIN_ENDPOINT = 'uservalid.cgi'

  @session = nil
  @rest_client = nil

  def initialize username, password, root_url, rest_client
    @username = username
    @password = password
    @root_url = root_url
    @rest_client = rest_client
  end
  
  def login
    response = @rest_client.post(@root_url + LOGIN_ENDPOINT, { UserName: @username, UserPassword: @password })
    body = JSON.parse(response.body)
    if body["sessvalid"] == '100' &&
       body["result"] == '200' &&
       body["session"] != nil
			@session = body['session']
    else
      puts "Error Logging In"
      exit
		end
  end

  def method_missing(method, *args)
    login if @session.nil?
    args[1] = {} if args[1].nil?
    args[1][:sessid] = @session
    response = @rest_client.send(method, *args)
    body = JSON.parse(response.body)
    if body['sessvalid'] != '100'
      login
      args[1][:sessid] = @session
      response = @rest_client.send(method, *args)
    end
    response
  end
end

