require 'active_support/notifications'
require 'faraday'
require 'typhoeus'
require 'typhoeus/adapters/faraday'
require 'faraday_middleware'
require 'storenvy/core/response_parser'
require 'storenvy/version'
require 'storenvy/api/order'
require 'storenvy/api/store'
require 'storenvy/api/template'
require 'storenvy/api/user'
require 'storenvy/api/product'


module Storenvy
  class Client
    include Storenvy::Order
    include Storenvy::Store
    include Storenvy::Template
    include Storenvy::User
    include Storenvy::Product

    attr_accessor :access_token

    #
    # Creates a new instance of Storenvy::Client
    #
    # @param url [String] The url to Storenvy api (https://api.storenvy.com)
    # @param parallel_requests [Integer String] The maximum parallel request to do (5)
    def initialize(url = 'https://api.storenvy.com', parallel_requests = 5)
      @url = url
      @parallel_requests = parallel_requests
    end

    #
    # Does a GET request to the url with the params
    #
    # @param url [String] the relative path in the Storenvy API
    # @param params [Hash] the url params that should be passed in the request
    def get(url, params = {})
      params = params.inject({}){|memo,(k,v)| memo[k.to_s] = v; memo}
      params[:access_token] = @access_token if @access_token
      preform(url, :get, params: params) do
        return connection.get(url, params)
      end
    end

    #
    # Does a POST request to the url with the params
    #
    # @param url [String] the relative path in the Storenvy API
    # @param params [Hash] the body of the request
    def post(url, params)
      params = convert_hash_keys(params)
      params[:access_token] = @access_token if @access_token
      preform(url, :post, params: params) do
        return connection.post(url, params)
      end
    end

    #
    # Does a PUT request to the url with the params
    #
    # @param url [String] the relative path in the Storenvy API
    # @param params [Hash] the body of the request
    def put(url, params)
      params = convert_hash_keys(params)
      params[:access_token] = @access_token if @access_token
      preform(url, :put, params: params) do
        return connection.put(url, params)
      end
    end

    #
    # Does a DELETE request to the url with the params
    #
    # @param url [String] the relative path in the Storenvy API
    def delete(url, params)
      params = convert_hash_keys(params)
      params[:access_token] = @access_token if @access_token
      preform(url, :delete) do
        return connection.delete(url)
      end
    end

    #
    # Does a parallel request to the api for all of the requests in the block
    #
    # @example block
    #   Storenvy.in_parallel do
    #     Storenvy.create_review(review_params)
    #     Storenvy.update_account(account_params)
    #   end
    def in_parallel
      connection.in_parallel do
        yield
      end
    end

    private

    #
    # Preforms an HTTP request and notifies the ActiveSupport::Notifications
    #
    # @private
    # @param url [String] the url to which preform the request
    # @param type [String]
    def preform(url, type, params = {}, &block)
      ActiveSupport::Notifications.instrument 'Storenvy', request: type, url: url, params: params do
        if connection.in_parallel?
          block.call
        else
          block.call.body
        end
      end
    end

    #
    # @return an instance of Faraday initialized with all that this gem needs
    def connection
      @connection ||= Faraday.new(url: @url, parallel_manager: Typhoeus::Hydra.new(max_concurrency: @parallel_requests), headers: {:storenvy_api_connector => 'Ruby'+ Storenvy::VERSION}) do |conn|

        conn.use Storenvy::ResponseParser

        # Set the response to be rashified
        conn.response :rashify

        # Setting request and response to use JSON/XML
        conn.request :oj
        conn.response :oj

        # Set to use instrumentals to get time logs
        conn.use :instrumentation

        conn.adapter :typhoeus
      end
    end
    private
    def convert_hash_keys(value)
      case value
        when Array
          value.map { |v| convert_hash_keys(v) }
        when Hash
          Hash[value.map { |k, v| [k.to_s, convert_hash_keys(v)] }]
        else
          value
      end
    end
  end
end