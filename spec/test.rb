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

signer = Universign::Sign.transactionSigner(
    '33 666666666', 'test@domain.com', 'Jackie', 'Chan',
    'http://www.test.com/success', 'http://www.test.com/fail', 'http://www.test.com/cancel'
)
document = Universign::Sign.transactionDocument(filecontent, 'test.pdf')
client = Universign::Sign.client

response = client.requestTransaction signer, document

transactionId = response['id']

puts "Redirect url : #{response['url']}"
puts "Transaction ID : #{transactionId}"

puts client.getTransactionInfo(transactionId).inspect
