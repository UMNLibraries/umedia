require 'net/http'
require 'uri'

# POST a message to a Slack channel
class NotifySlack
  attr_reader :slack_url, :message, :http_klass, :http_post_klass
  def initialize(message: :MISSING_MESSAGE,
                 slack_url: ENV['CDM_ERROR_SLACK_WEBHOOK_URL'],
                 http_klass: Net::HTTP,
                 http_post_klass: Net::HTTP::Post)
    @message = message
    @slack_url = slack_url
    @http_klass = http_klass
    @http_post_klass = http_post_klass
  end

  def uri
    URI.parse slack_url
  end

  def post
    http_klass.post_form(uri, "payload" => payload )
  end

  def payload
    { "text": message }.to_json
  end

  def request
    @request ||=
      http_post_klass.new(uri)
      request['cache-control'] = 'no-cache'
  end

  def http
    @http ||=
      http_klass.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
end
