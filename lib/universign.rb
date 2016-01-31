# encoding: utf-8
require 'universign/version'
require 'universign/hash'
require 'base64'
require 'xmlrpc/client'

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
      SignerDefaultOptions = { firstname: nil,
                               lastname: nil,
                               organization: nil,
                               profile: 'default',
                               emailAddress: nil,
                               phoneNum: nil,
                               role: 'signer',
                               signatureField: nil,
                               successURL: nil,
                               cancelURL: nil,
                               failURL: nil,
                               certificateType: 'simple',
                               idDocuments: nil
      }.freeze
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

      def transaction_signer(options = {})
        options = options.reverse_merge(SignerDefaultOptions)
        validate_transaction_signer_argument options
        options.reject! { |_, v| v.nil? }
      end

      def transaction_document(content, name)
        { content: XMLRPC::Base64.new(content), name: name }
      end

      private

      def validate_transaction_signer_argument(options)
        fail(ArgumentError, 'You have to provide a firstname') if
            options[:firstname].empty?
        fail(ArgumentError, 'You have to provide a lastname') if
            options[:lastname].empty?
        fail(ArgumentError, 'You have to provide an email') if
            options[:emailAddress].empty?
      end
    end

    class Client < XMLRPC::Client
      # Request signature (Client side)
      def request_transaction(signers, docs)
        signers = [signers] unless signers.is_a? Array
        docs = [docs] unless docs.is_a? Array
        request = { documents: docs, signers: signers,
                    handwrittenSignatureMode: 0,
                    profile: Universign.configuration.profile,
                    language: Universign.configuration.language }
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
