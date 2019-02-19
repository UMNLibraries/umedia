require 'uri'

# Note: the aws-sdk is installed for DEVELOPMENT ENVIRONMENTS ONLY
# in order to keep spreading AWS credentials to a minimum
class DeleteThumbnails
  attr_reader :page, :bucket, :search, :docs
  def initialize(param_string: :MISSING_PARAM_STRING,
                 page: 1,
                 bucket: :MISSING_BUCKET,
                 s3_resource: Aws::S3::Resource.new,
                 search_klass: SearchWithChildren)
    @bucket = s3_resource.bucket(bucket)
    @docs = search_klass.new(param_string: param_string, page: page).docs
  end

  def delete!
    thumbs.map do |thumb|
      Rails.logger.info "Deleting Thumb: #{thumb}"
      bucket.object(thumb).delete
    end
    thumbs
  end

  def last_batch?
    docs.length <= 0
  end

  private

  def next_page
    page + 1
  end

  def thumbs
    @thumbs ||= docs.map do |doc|
      [
        thumb(doc),
        doc.fetch('children', []).map { |child| thumb(child) }
      ]
    end.flatten
  end

  def thumb(doc)
    doc['thumb_cdn_url'].split('/').last
  end
end
