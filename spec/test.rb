$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'universign.rb'

Universign.configure do |config|
  config.user = ENV['UNIVERSIGN_USER']
  config.password = ENV['UNIVERSIGN_PASSWORD']
  config.language = 'fr'
  config.profile = 'default'
  #config.debug = true
end

filecontent = File.read File.expand_path('../../spec/test.pdf', __FILE__)

test_signer = {
    phoneNum: '33 666666666',
    emailAddress: 'test@domain.com',
    firstname: 'Jackie',
    lastname: 'Chan',
    successURL: 'http://www.test.com/success',
    failURL: 'http://www.test.com/fail',
    cancelURL: 'http://www.test.com/cancel',
}

signer = Universign::Sign.transaction_signer(test_signer)

document = Universign::Sign.transaction_document(filecontent, 'test.pdf')
client = Universign::Sign.client

response = client.request_transaction signer, document

transactionId = response['id']

puts "Redirect url : #{response['url']}"
puts "Transaction ID : #{transactionId}"

puts client.get_transaction_info(transactionId).inspect
