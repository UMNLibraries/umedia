# Basic solr connection config and solr conveniences
class SolrClient
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

  def delete_index
    solr.delete_by_query '*:*'
    solr.commit
  end

  def commit
    solr.commit
  end

  def optimize
    solr.optimize
  end

  def add(records)
    solr.add records
  end

  def backup(number_to_keep: 1)
    solr.get 'replication', params: {
      command: 'backup',
      location: ENV['SOLR_BACKUP_LOCATION'],
      'numberToKeep' => number_to_keep
    }
  end

  private

  def base_url
    'http://solr'
  end
end
