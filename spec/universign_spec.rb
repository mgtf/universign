require 'spec_helper'

describe Universign::Sign do

  it 'has a version number' do
    expect(Universign::VERSION).not_to be nil
    expect(Universign::VERSION).to be_a String
  end

  context 'without configuration provided' do
    it 'must fail to call client method' do
      expect{ Universign::Sign.client }.to raise_error RuntimeError
    end
  end

  context 'with configuration provided' do
    before(:each) do
      Universign.configure do | config |
        config.user = 'testuser'
        config.password = 'testpassword'
      end
    end

    let(:client) { Universign::Sign.client }

    it 'client method must instance Universign::Sign::Client class' do
      expect(client).to be_a Universign::Sign::Client
      expect(client).to be_kind_of XMLRPC::Client
    end
  end

  context 'without minimal client options' do
    it 'must fail to call transaction_signer' do
      expect{Universign::Sign.transaction_signer(firstname: 'Jackie')}.to raise_error ArgumentError
      expect{Universign::Sign.transaction_signer(lastname: 'Chan')}.to raise_error ArgumentError
    end
  end

  context 'with minimal client options' do
    it 'must success to call transaction_signer' do
      expect{
          Universign::Sign.transaction_signer(
              firstname: 'Jackie',
              lastname: 'Chan',
              emailAddress: 'jc@test.com'
          )
      }.not_to raise_error
    end
  end

end
