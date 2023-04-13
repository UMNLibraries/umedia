# frozen_string_literal: true

require 'uri'
require 'cgi'
require 'i18n'

class RightsStatements
  attr_reader :rights_uri
  def initialize(rights_uri: :MISSING_RIGHTS_URI)
    # Remove query from rights URI (which may hold locale)
    @rights_uri = rights_uri
    @rights_uri = @rights_uri.chomp('/') if @rights_uri
    # Set locale based on input rights URI language
    @locale = CGI.parse(URI.parse(rights_uri).query)['language'].first.to_sym rescue :en
  end

  def config
    {
      # Match the input URI without its protocol
      images: images[rights_statement_uri_no_proto],
      text: I18n.translate(:rights, locale: @locale)[rights_statement_uri_no_proto&.to_sym]
    }
  end

  private

  def images
    {
      # Store these without http: https: protos because they may differ in metadata
      '//rightsstatements.org/vocab/CNE/1.0' => ['CNE-1.0.svg'],
      '//rightsstatements.org/vocab/InC-EDU/1.0' => ['InC-EDU-1.0.svg'],
      '//rightsstatements.org/vocab/InC-NC/1.0' => ['InC-NC-1.0.svg'],
      '//rightsstatements.org/vocab/InC-RUU/1.0' => ['InC-RUU-1.0.svg'],
      '//rightsstatements.org/vocab/InC/1.0' => ['InC-1.0.svg'],
      '//rightsstatements.org/page/InC/1.0' => ['InC-1.0.svg'],
      '//rightsstatements.org/vocab/NKC/1.0' => ['NKC-1.0.svg'],
      '//rightsstatements.org/vocab/NoC-CR/1.0' => ['NoC-CR-1.0.svg'],
      '//rightsstatements.org/vocab/NoC-NC/1.0' => ['NoC-NC-1.0.svg'],
      '//rightsstatements.org/vocab/NoC-OKLR/1.0' => ['NoC-OKLR-1.0.svg'],
      '//rightsstatements.org/vocab/NoC-US/1.0' => ['NoC-US-1.0.svg'],
      '//rightsstatements.org/vocab/UND/1.0' => ['UND-1.0.svg'],
      '//creativecommons.org/licenses/by-nc/4.0' => ['cc_icon_white_x2.png', 'attribution_icon_white_x2.png', 'nc_white_x2.png'],
      '//creativecommons.org/licenses/by/3.0' => ['cc_icon_white_x2.png', 'attribution_icon_white_x2.png'],
      '//creativecommons.org/publicdomain/mark/1.0' => ['cc_icon_white_x2.png', 'pd_white_x2.png']
    }
  end

  def rights_statement_uri
    rights_uri.split('?').first.chomp('/')
  end

  def rights_statement_uri_no_proto
    rights_statement_uri.sub(/^https?:/, '')
  end
end
