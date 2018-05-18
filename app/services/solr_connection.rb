# Basic solr connection config
class SolrConnection
  attr_reader :core_name, :solr_klass
  def initialize(core_name: ENV['RAILS_ENV'], solr_klass: RSolr)
    @core_name = core_name
    @solr_klass = solr_klass
  end

  def solr
    @solr ||= solr_klass.connect url: url
  end

  def url
    "#{base_url}:8983/solr/#{core_name}"
  end

  private

  def base_url
    core_name == 'production' ? 'http://localhost' : 'http://solr'
  end
end