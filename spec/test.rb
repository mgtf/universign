$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'universign.rb'

puts '--------------------------------------------------------------------'
puts '                  -= Universign test script =-'
puts 'Note that you have to create a developer account first (sandbox)'
puts 'and set UNIVERSIGN_USER and UNIVERSIGN_PASSWORD environment variable'
puts '--------------------------------------------------------------------'

fail 'You have to set UNIVERSIGN_USER environment variable' if ENV['UNIVERSIGN_USER'].to_s == ''
fail 'You have to set UNIVERSIGN_PASSWORD environment variable' if ENV['UNIVERSIGN_PASSWORD'].to_s == ''

Universign.configure do |config|
  config.user = ENV['UNIVERSIGN_USER']
  config.password = ENV['UNIVERSIGN_PASSWORD']
  config.language = 'fr'
  config.profile = 'default'
  # config.debug = true
end

filecontent = File.read File.expand_path('../../spec/test.pdf', __FILE__)

test_signer = {
  phoneNum: '33666666666',
  emailAddress: 'signeremail@domain.com',
  firstname: 'SignerFirstname',
  lastname: 'SignerLastname',
  successURL: 'http://www.test.com/success',
  failURL: 'http://www.test.com/fail',
  cancelURL: 'http://www.test.com/cancel',
  universignId: 'internal-id-12',
  signatureField: { page: 1, x: 10, y: 10, signerIndex: 0 }
}

signer = Universign::Sign.transaction_signer(test_signer)

document = Universign::Sign.transaction_document(filecontent, 'test.pdf')
client = Universign::Sign.client

response = client.request_transaction signer, document, {
  finalDocSent: true,
  handwrittenSignatureMode: 1,
  description: 'Transaction name'
}

transaction_id = response['id']

puts "Redirect url : #{response['url']}"
puts "Transaction ID : #{transaction_id}"

puts client.get_transaction_info(transaction_id).inspect
