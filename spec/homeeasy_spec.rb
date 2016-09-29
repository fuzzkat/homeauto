require 'homeeasy'

LOGIN_ENDPOINT = 'http://homeeasy/cgi-bin/uservalid.cgi'

RSpec.describe HomeEasy, "#init" do

  context "when initialized with valid credentials" do
    it "initializes a session" do
      rest_client = class_double "RestClient"
			response = double("Response", :body => '{"sessvalid":"100","result":"200","usertype":"admin","session":"JD3DSE"}')
      expect(rest_client).to receive(:post).with(LOGIN_ENDPOINT, { UserName: 'fakeuser', UserPassword: 'goodpassword' } ) { response }

      homeeasy = HomeEasy.new 'fakeuser', 'goodpassword', rest_client
      expect(homeeasy.status).to eq :connected
    end
  end

  context "when initialized with invalid credentials" do
    it "reports status as :failed" do
      rest_client = class_double "RestClient"
			response = double("Response", :body => '{"sessvalid": "100", "result": "515", "usertype":"admin", "session": "JD3DSE"}')
      expect(rest_client).to receive(:post).with(LOGIN_ENDPOINT, { UserName: 'fakeuser', UserPassword: 'badpassword' } ) { response }

      homeeasy = HomeEasy.new 'fakeuser', 'badpassword', rest_client
      expect(homeeasy.status).to eq :failed
    end
  end

  context "when session is invalid whatever that means" do
    it "reports status as :failed" do
      rest_client = class_double "RestClient"
			response = double("Response", :body => '{"sessvalid": "999", "result": "200", "usertype":"admin", "session": "JD3DSE"}')
      expect(rest_client).to receive(:post).with(LOGIN_ENDPOINT, { UserName: 'fakeuser', UserPassword: 'goodpassword' } ) { response }

      homeeasy = HomeEasy.new 'fakeuser', 'goodpassword', rest_client
      expect(homeeasy.status).to eq :failed
    end
  end

  context "when session is not returned" do
    it "reports status as :failed" do
      rest_client = class_double "RestClient"
			response = double("Response", :body => '{"sessvalid": "100", "result": "200", "usertype":"admin"}')
      expect(rest_client).to receive(:post).with(LOGIN_ENDPOINT, { UserName: 'fakeuser', UserPassword: 'goodpassword' } ) { response }
      homeeasy = HomeEasy.new 'fakeuser', 'goodpassword', rest_client
      expect(homeeasy.status).to eq :failed
    end
  end


end


