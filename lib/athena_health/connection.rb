require 'json'

module AthenaHealth
  class Connection
    BASE_URL    = 'https://api.athenahealth.com'.freeze
    AUTH_PATH   = { 'v1' => 'oauth', 'preview1' => 'oauthpreview', 'openpreview1' => 'oauthopenpreview' }

    def initialize(version:, key:, secret:)
      @version = version
      @key = key
      @secret = secret
    end

    def authenticate
      response = Typhoeus.post(
        "#{BASE_URL}/#{AUTH_PATH[@version]}/token",
        userpwd: "#{@key}:#{@secret}",
        body: { grant_type: 'client_credentials' }
      ).response_body

      @token = JSON.parse(response)['access_token']
    end

    def call(endpoint:, method:, params: {}, body: {}, second_call: false)
      authenticate if @token.nil?

      response = Typhoeus::Request.new(
        "#{BASE_URL}/#{@version}/#{endpoint}",
        method: method,
        headers: { "Authorization" => "Bearer #{@token}"},
        params: params,
        body: body,
      ).run

      if response.response_code == 401 && !second_call
        authenticate
        call(endpoint: endpoint, method: method, second_call: true)
      end

      body = JSON.parse(response.response_body)

      if [400, 409].include? response.response_code
        fail AthenaHealth::ValidationError.new(body)
      end

      if response.response_code != 200
        AthenaHealth::Error.new(code: response.response_code).render
      end

      body
    end
  end
end
