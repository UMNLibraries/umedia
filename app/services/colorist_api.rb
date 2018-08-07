class ColoristApi
  attr_reader :api_uri,
              :api_key,
              :thumb_url,
              :aws_api_klass

  def initialize(thumb_url: :missing_thumb_url,
                 api_uri: ENV['UMEDIA_COLORIST_API_URI'],
                 api_key: ENV['UMEDIA_COLORIST_API_KEY'],
                 aws_api_klass: AwsApi)
    @api_uri            = api_uri
    @api_key            = api_key
    @thumb_url          = CGI.escape thumb_url
    @aws_api_klass      = aws_api_klass
  end

  def get_colors
    JSON.parse(aws_api_klass.new(url: api_url, api_key: api_key).post)
  end

  private

  def api_url
    "#{api_uri}?url=#{thumb_url}"
  end
end
