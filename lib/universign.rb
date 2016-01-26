require 'universign/version'

module Universign
  # Your code goes here...


  # encoding : utf-8require 'rubygems'require 'base64'require 'httparty'
=begin
  class Timestamp
    include HTTParty
    base_uri 'https://ws.universign.eu/tsa/'

    def self.doTsp(login, pwd, hashAlgo, hashValue, withCert)
      data = { :hashAlgo => hashAlgo, :hashValue => hashValue, :withCert => withCert }
      h = {
          'content-type' => 'application/x-www-form-urlencoded',
          'authorization' => "Basic #{Base64.encode64("#{login + ":" + pwd}")}"
      }
      return post('/post', :headers=> h, :body => data)
    end
  end
=end

end
