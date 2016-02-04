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
                  :profile, :handwritten_signature_mode

    def initialize
      @language = 'en'
      @debug = false
      @production = false
      @profile = 'default'
      @handwritten_signature_mode = 0
    end
  end

  module Sign
    class << self
      SANDBOX_URL = 'sign.test.cryptolog.com'.freeze
      PROD_URL = 'sign.cryptolog.com'.freeze
      PATH = '/sign/rpc'.freeze

      def client
        fail 'You need to set config options' if Universign.configuration.nil?
        host = Universign.configuration.production ? PROD_URL : SANDBOX_URL
        client = Universign::Sign::Client.new(
            host, PATH, nil, nil, nil,
            Universign.configuration.user,
            Universign.configuration.password, true
        )
        client.set_debug if Universign.configuration.debug
        client
      end

      def transaction_signer(options = {})
        validate_transaction_signer_argument options
        options
      end

      def transaction_document(content, name, option = {})
        { content: XMLRPC::Base64.new(content), name: name }.merge option
      end

      private

      def validate_transaction_signer_argument(options)
        fail(ArgumentError, 'You have to provide a firstname') if
            options[:firstname].to_s == ''
        fail(ArgumentError, 'You have to provide a lastname') if
            options[:lastname].to_s == ''
        fail(ArgumentError, 'You have to provide an email') if
            options[:emailAddress].to_s == ''
      end
    end

    class Client < XMLRPC::Client
      # Request signature (Client side)
      def request_transaction(signers, docs, options = {})
        options[:documents] = (docs.is_a? Array) ? docs : [docs]
        options[:signers] = (signers.is_a? Array) ? signers : [signers]
        request = options.reverse_merge(
            handwrittenSignatureMode: \
            Universign.configuration.handwritten_signature_mode,
            profile: Universign.configuration.profile,
            language: Universign.configuration.language
        )
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
