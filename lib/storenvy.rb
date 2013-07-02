require 'storenvy/version'
require 'storenvy/client'

module Storenvy
  class << self
    # @!attribute url
    # @return [String] the base url of the Storenvy Api
    attr_accessor :url

    # @!attribute parallel_requests
    # @return [Integer String] defines the maximum parallel request for the gem to preform
    attr_accessor :parallel_requests

    # @!attribute app_key
    # @return [String] the app key that is registered with Storenvy
    attr_accessor :app_key

    # @!attribute secret
    # @return [String] the secret that is registered with Storenvy
    attr_accessor :secret

    # Configuration interface of the gem
    #
    # @yield [self] to accept configuration settings
    def configure
      yield self
      true
    end

    #
    # Makes sure that the method missing is checked with the Storenvy::Client instance
    #
    # @param method_name [String] the name of the method we want to run
    # @param include_private [Boolean] defines wether to check for private functions as well
    def respond_to_missing?(method_name, include_private=false)
      client.respond_to?(method_name, include_private)
    end

    #
    # @return an instance of Storenvy::Client
    #
    def client
      @client ||= Storenvy::Client.new()
    end

    private

    #
    # executes any function on the Storenvy::Client instance
    #
    # @param args [*] any argument that we want to pass to the client function
    # @param block [Block] any block that is passed to the client function
    def method_missing(method_name, *args, &block)
      return super unless client.respond_to?(method_name)
      client.send(method_name, *args, &block)
    end
  end
end
