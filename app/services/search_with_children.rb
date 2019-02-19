class SearchWithChildren
  attr_reader :param_string, :rows, :page, :bucket, :http_client, :base_url
  def initialize(param_string: :MISSING_PARAM_STRING,
                 http_client: HTTP,
                 page: 1,
                 rows: 100,
                 base_url: ENV['RAILS_BASE_URL'])
    @param_string = param_string
    @page = page
    @rows = rows
    @http_client = http_client
    @base_url = base_url
  end

  def docs
    results.map do |result|
      if result['is_compound']
        result.merge(children(result))
      else
        result
      end
    end
  end

  private

  def children(doc)
    get "#{base_url}/item/#{doc['id']}.json"
  end

  def get(url)
    JSON.parse http_client.get url
  end

  def results
    @results ||= get search_url
  end

  def search_url
    "#{base_url}/search.json?#{param_string}&page=#{page}&rows=#{rows}"
  end
end
