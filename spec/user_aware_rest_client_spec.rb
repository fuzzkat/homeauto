require 'user_aware_rest_client'

RSpec.describe UserAwareRestClient, '#method_missing' do
  
  context "when user has not logged in" do
    let(:login_response) { double("Response", :body => '{"sessvalid":"100","result":"200","usertype":"admin","session":"JD3DSE"}') }
    let(:query_response) { double("Response", :body => '{"sessvalid":"100","result":"200","somekey":"somevalue"}') }
    let(:rest_client) { class_double "RestClient" }
    let(:user_aware_rest_client) { UserAwareRestClient.new 'user', 'password', 'http://root_url/', rest_client }

    it "augments the rest query with sessionid obtained by logging in" do
      expect(rest_client).to receive(:post).with('http://root_url/' + UserAwareRestClient::LOGIN_ENDPOINT, { UserName: 'user', UserPassword: 'password'}) { login_response } 
      expect(rest_client).to receive(:post).with('http://root_url/foo', { key: 'value', sessid: 'JD3DSE' }) { query_response } 
      expect(user_aware_rest_client.post('http://root_url/foo', { key: 'value' })).to eq(query_response)
    end

    it "augments second query without logging in twice" do
      expect(rest_client).to receive(:post).once.with('http://root_url/' + UserAwareRestClient::LOGIN_ENDPOINT, { UserName: 'user', UserPassword: 'password'}) { login_response } 
      expect(rest_client).to receive(:post).twice.with('http://root_url/foo', { key: 'value', sessid: 'JD3DSE' }) { query_response } 
      expect(user_aware_rest_client.post('http://root_url/foo', { key: 'value' })).to eq(query_response)
      expect(user_aware_rest_client.post('http://root_url/foo', { key: 'value' })).to eq(query_response)
    end

    before do
      allow(rest_client).to receive(:post).with('http://root_url/' + UserAwareRestClient::LOGIN_ENDPOINT, { UserName: 'user', UserPassword: 'password'}) { login_response } 
      allow(rest_client).to receive(:post).with('http://root_url/foo', { sessid: 'JD3DSE' }) { query_response } 
    end
    it "adds sessionid even if no parameters are passed in" do
      expect(user_aware_rest_client.post('http://root_url/foo')).to eq(query_response)
    end
  end

  context "when session has expired" do
    let(:login_response_1)           { double("Login Response", :body => '{"sessvalid":"100","result":"200","usertype":"admin","session":"JD3DSE"}') }
    let(:login_response_2)           { double("Login Response", :body => '{"sessvalid":"100","result":"200","usertype":"admin","session":"ESD3DJ"}') }
    let(:session_expired_response) { double("Session Expired Response", :body => '{"sessvalid":"401"}') }
    let(:query_response)           { double("Query Response", :body => '{"sessvalid":"100","result":"200","somekey":"somevalue"}') }
    let(:rest_client)              { class_double "RestClient" }
    let(:user_aware_rest_client) { UserAwareRestClient.new 'user', 'password', 'http://root_url/', rest_client }

    before do
      allow(rest_client).to receive(:post).with('http://root_url/' + UserAwareRestClient::LOGIN_ENDPOINT, { UserName: 'user', UserPassword: 'password'}) { login_response_1 } 
      allow(rest_client).to receive(:post).with('http://root_url/foo', { sessid: 'JD3DSE' }) { session_expired_response } 
      allow(rest_client).to receive(:post).with('http://root_url/' + UserAwareRestClient::LOGIN_ENDPOINT, { UserName: 'user', UserPassword: 'password'}) { login_response_2 } 
      allow(rest_client).to receive(:post).with('http://root_url/foo', { sessid: 'ESD3DJ' }) { query_response } 
    end

    it "logs in again to create a new session" do
      expect(user_aware_rest_client.post('http://root_url/foo')).to eq(query_response)
    end
  end
end
