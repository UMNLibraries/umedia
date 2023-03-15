module ApplicationHelper
  def active_link_to(name = nil, options = nil, html_options = nil, &block)
    url_string = URI.parser.unescape(url_for(options)).force_encoding(Encoding::BINARY)
    active_class = html_options[:active] || "active"
    html_options.delete(:active)
    html_options[:class] = "#{html_options[:class]} #{active_class}" if current_page?(options)
    link_to(name, options, html_options, &block)
  end

  # Allow language= param to be passed and check against defined I18n locales
  def locale
    lang = params.fetch(:language, I18n.default_locale).to_sym
    I18n.available_locales.include?(lang) ? lang : I18n.default_locale
  end
end
