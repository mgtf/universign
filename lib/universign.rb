# encoding: utf-8
require 'universign/version'
require 'base64'
require 'xmlrpc/client'

# Universign XML-RPC API
module Universign
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end

  # Configuration class
  class Configuration
    attr_accessor :language, :production, :user, :password, :debug,
                  :profile

    def initialize
      @language = 'en'
      @debug = false
      @production = false
      @profile = 'default'
    end
  end

  module Sign
    class << self
      Document = Struct.new(:content, :name)
      Signer = Struct.new(
          :phoneNum,
          :emailAddress,
          :firstname,
          :lastname,
          :successURL,
          :failURL,
          :cancelURL
      )
      SANDBOX_URL = 'sign.test.cryptolog.com'.freeze
      PROD_URL = 'sign.cryptolog.com'.freeze

      def client
        fail 'You need to set config options' if Universign.configuration.nil?
        host = Universign.configuration.production ? PROD_URL : SANDBOX_URL
        path = '/sign/rpc'
        client = Universign::Sign::Client.new(
            host, path, nil, nil, nil,
            Universign.configuration.user,
            Universign.configuration.password, true
        )
        client.set_debug if Universign.configuration.debug
        client
      end

      def transaction_signer(h = {})
        Signer.new(
            h[:phone_num], h[:email_address],
            h[:firstname], h[:lastname],
            h[:success_url], h[:fail_url], h[:cancel_url]
        )
      end

      def transaction_document(content, name)
        Document.new(XMLRPC::Base64.new(content), name)
      end
    end

    class Client < XMLRPC::Client
      RequestTransaction = Struct.new(
          :documents,
          :signers,
          :handwrittenSignatureMode,
          :profile,
          :certificateType,
          :language
      )

      # Request signature (Client side)
      def request_transaction(signers, docs)
        signers = [signers] unless signers.is_a? Array
        docs = [docs] unless docs.is_a? Array
        request = RequestTransaction.new(docs, signers,
                                         0,
                                         Universign.configuration.profile,
                                         'simple',
                                         Universign.configuration.language)
        call('requester.requestTransaction', request)
      end

      def get_transaction_info(transaction_id)
        call('requester.getTransactionInfo', transaction_id)
      end

      def get_documents(transaction_id)
        call('requester.getDocuments', transaction_id)
      end

      def set_debug
        @http.set_debug_output($stderr)
      end
    end
  end
end
