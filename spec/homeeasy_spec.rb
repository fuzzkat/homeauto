require 'homeeasy'

LOGIN_ENDPOINT = 'http://homeeasy/cgi-bin/uservalid.cgi'

RSpec.describe HomeEasy, "#init" do

  context "when initialized with valid credentials" do
    let(:response) { double("Response", :body => '{"sessvalid":"100","result":"200","usertype":"admin","session":"JD3DSE"}') }
    let(:rest_client) { class_double "RestClient" }
    let(:homeeasy) { HomeEasy.new 'fakeuser', 'goodpassword', rest_client }
    before do
      allow(rest_client).to receive(:post).with(LOGIN_ENDPOINT, { UserName: 'fakeuser', UserPassword: 'goodpassword' } ) { response }
    end
    it "initializes a session" do
      expect(homeeasy.status).to eq :connected
    end
  end

  context "when initialized with invalid credentials" do
    let(:response) { double("Response", :body => '{"sessvalid": "100", "result": "515", "usertype":"admin", "session": "JD3DSE"}') }
    let(:rest_client) { class_double "RestClient" }
    let(:homeeasy) { HomeEasy.new 'fakeuser', 'badpassword', rest_client }
    before do
      allow(rest_client).to receive(:post).with(LOGIN_ENDPOINT, { UserName: 'fakeuser', UserPassword: 'badpassword' } ) { response }
    end
    it "reports status as :failed" do
      expect(homeeasy.status).to eq :failed
    end
  end

  context "when session is invalid whatever that means" do
	  let(:response) { double("Response", :body => '{"sessvalid": "999", "result": "200", "usertype":"admin", "session": "JD3DSE"}') }
    let(:rest_client) { class_double "RestClient" }
    let(:homeeasy) { HomeEasy.new 'fakeuser', 'goodpassword', rest_client }
    before do
      allow(rest_client).to receive(:post).with(LOGIN_ENDPOINT, { UserName: 'fakeuser', UserPassword: 'goodpassword' } ) { response }
    end
    it "reports status as :failed" do
      expect(homeeasy.status).to eq :failed
    end
  end

  context "when session is not returned" do
	  let(:response) { double("Response", :body => '{"sessvalid": "100", "result": "200", "usertype":"admin"}') }
    let(:rest_client) { class_double "RestClient" }
    let(:homeeasy) { HomeEasy.new 'fakeuser', 'goodpassword', rest_client }
    before do
      allow(rest_client).to receive(:post).with(LOGIN_ENDPOINT, { UserName: 'fakeuser', UserPassword: 'goodpassword' } ) { response }
    end
    it "reports status as :failed" do
      expect(homeeasy.status).to eq :failed
    end
  end

end

