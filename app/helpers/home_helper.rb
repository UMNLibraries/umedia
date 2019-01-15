module HomeHelper
  def record_count
    Rails.cache.fetch("record_count", expires_in: 12.hours) do
      number_with_delimiter(Umedia::RecordCountSearch.new.count, :delimiter => ',')
    end
  end
end
