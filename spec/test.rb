$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'universign.rb'

Universign.configure do |config|
  config.user = '<usually your email>'
  config.password = '<password>'
  config.language = 'fr'
end

filecontent = File.read File.expand_path('../../spec/test.pdf', __FILE__)

signer = Universign::Sign.transactionSigner('33 666666666', 'test@domain.com', 'Jackie', 'Chan')
document = Universign::Sign.transactionDocument(filecontent, 'test.pdf')
client = Universign::Sign.client
puts client.requestTransaction(
    signer, document, 'http://www.test.com/success', 'http://www.test.com/cancel', 'http://www.test.com/fail'
).to_s
