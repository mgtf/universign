require 'spec_helper'

describe Universign::Sign do

  it 'has a version number' do
    expect(Universign::VERSION).not_to be nil
    expect(Universign::VERSION).to be_a String
  end

  context 'without credentials provided' do
    it 'should fail to create a new instance' do
      expect{ Universign::Sign.client }.to raise_error RuntimeError
    end
  end

  context 'with credentials provided' do
    before(:each) do
      Universign.configure do | config |
        config.user = 'testuser'
        config.password = 'testpassword'
      end
    end

    let(:client) { Universign::Sign.client }

    it 'client method builds a Universign::Sign::Client' do
      expect(client).to be_a Universign::Sign::Client
      expect(client).to be_kind_of XMLRPC::Client
    end
  end
end
