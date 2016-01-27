# encoding: utf-8
require 'universign/version'
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

      def client
        raise 'You need to set config options' if Universign.configuration.nil?
        host = Universign.configuration.production ? 'sign.cryptolog.com' : 'sign.test.cryptolog.com'
        path = '/sign/rpc'
        client = Universign::Sign::Client.new(
            host, path, nil, nil, nil, Universign.configuration.user, Universign.configuration.password, true
        )
        client.set_debug if Universign.configuration.debug
        client
      end

    end

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

    def self.transactionSigner(phoneNum, emailAddress, firstname, lastname, successURL, failURL, cancelURL)
      Signer.new(phoneNum, emailAddress, firstname, lastname, successURL, failURL, cancelURL)
    end

    def self.transactionDocument(content, name)
      Document.new(XMLRPC::Base64.new(content), name)
    end

    class Client < XMLRPC::Client

      ContractSignatureRequest = Struct.new(
          :documents,
          :signers,
          :handwrittenSignatureMode,
          :profile,
          :certificateType,
          :language
      )

      # Request signature (Client side)
      def requestTransaction(transactionSigners, transactionDocuments)
        transactionSigners = [transactionSigners] unless transactionSigners.is_a? Array
        transactionDocuments = [transactionDocuments] unless transactionDocuments.is_a? Array
        request = ContractSignatureRequest.new(
            transactionDocuments,
            transactionSigners,
            0,
            Universign.configuration.profile,
            'simple',
            Universign.configuration.language
        )
        call('requester.requestTransaction', request)
      end

      def set_debug
        @http.set_debug_output($stderr);
      end

    end
  end
end
