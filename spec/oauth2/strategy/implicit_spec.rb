require 'helper'

describe OAuth2::Strategy::Implicit do
  let(:client) { OAuth2::Client.new('abc', 'def', :site => 'http://api.example.com') }

  subject {client.implicit}

  describe "#authorize_url" do
    it "includes the client_id" do
      expect(subject.authorize_url).to include('client_id=abc')
    end

    it "includes the type" do
      expect(subject.authorize_url).to include('response_type=token')
    end

    it "includes passed in options" do
      cb = 'http://myserver.local/oauth/callback'
      expect(subject.authorize_url(:redirect_uri => cb)).to include("redirect_uri=#{RackOauth2::Utils.escape(cb)}")
    end
  end

  describe "#get_token" do
    it "raises NotImplementedError" do
      expect{subject.get_token}.to raise_error(NotImplementedError)
    end
  end
end
