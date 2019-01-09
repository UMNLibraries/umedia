module ChildSearchesHelper

  def children
    @children
  end

  def pages
    children.items.each_with_index.map do |child, page|
      render 'child_searches/page', child: child,
                                    page: page,
                                    active_child_id: params['active_child_id'],
                                    highlighting: highlighting(child),
                                    thumbnail: thumbnail(child)
    end.join(' ')
  end

  def highlighting(child)
    children.highlighting.fetch("#{child.collection}:#{child.id}", {})
  end

  def thumbnail(child)
    Umedia::Thumbnail::Url.new(item: child)
  end

  def num_found
    @children.num_found
  end

  def hl(highlight, field)
    return highlight.fetch(field, [])
  end

  def highlighter(field, label)
    return unless field.length > 0
    '<div class="highlight">' +
    "<div class=\"highlight-label\">#{label}:</div>" +
    "<div class=\"highlight-data\">#{field.join('...')}</div>" +
    '</div>'
  end
end
