module ChildSearchesHelper

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
