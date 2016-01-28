require 'spec_helper'

describe Universign::Sign do
  it 'has a version number' do
    expect(Universign::VERSION).not_to be nil
    expect(Universign::VERSION).to be_a String
  end

  before(:each) do
    Universign.configure do | config |
      config.user = 'testuser'
      config.password = 'testpassword'
    end
  end

  let(:client) { Universign::Sign.client }

  it 'client method builds a XMLRPC::Client' do
    expect(client).to be_a Universign::Sign::Client
  end
end
