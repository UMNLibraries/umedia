# frozen_string_literal: true

class RightsStatements
  attr_reader :rights_uri
  def initialize(rights_uri: :MISSING_RIGHTS_URI)
    @rights_uri = rights_uri
  end

  def config
    to_h[rights_statement_uri]
  end

  private

  def to_h
    {
      'http://rightsstatements.org/vocab/CNE/1.0' => { images: ['CNE-1.0.svg'], text: 'The copyright and related rights status of this Item has not been evaluated. You are free to use this Item in any way that is permitted by the copyright and related rights legislation that applies to your use.' },
      'http://rightsstatements.org/vocab/InC-EDU/1.0' => { images: ['InC-EDU-1.0.svg'], text: 'The University of Minnesota believes this Item is protected by copyright and/or related rights. You are free to use this Item in any way that is permitted by the copyright and related rights legislation that applies to your use. In addition, no permission is required from the rights-holder(s) for educational uses. For other uses, you need to obtain permission from the rights-holder(s).' },
      'http://rightsstatements.org/vocab/InC-NC/1.0' => { images: ['InC-NC-1.0.svg'], text: 'The University of Minnesota believes this Item is protected by copyright and/or related rights. You are free to use this Item in any way that is permitted by the copyright and related rights legislation that applies to your use. In addition, no permission is required from the rights-holder(s) for non-commercial uses. For other uses you need to obtain permission from the rights-holder(s).' },
      'http://rightsstatements.org/vocab/InC-RUU/1.0' => { images: ['InC-RUU-1.0.svg'], text: 'The University of Minnesota believes that this iItem is protected by copyright and/or related rights. However, for this item, either (a) no rights-holder(s) have been identified or (b) one or more rights-holder(s) have been identified but none have been located. You are free to use this item in any way that is permitted by the copyright and related rights legislation that applies to your use.' },
      'http://rightsstatements.org/vocab/InC/1.0' => { images: ['InC-1.0.svg'], text: 'The University of Minnesota believes that this item is protected by copyright and/or related rights. You are free to use this Item in any way that is permitted by the copyright and related rights legislation that applies to your use. For other uses you need to obtain permission from the rights-holder(s).' },
      'http://rightsstatements.org/vocab/NKC/1.0' => { images: ['NKC-1.0.svg'], text: 'The University of Minnesota reasonably believes that the item is not restricted by copyright or related rights, but a conclusive determination could not be made. You are free to use this Item in any way that is permitted by the copyright and related rights legislation that applies to your use.' },
      'http://rightsstatements.org/vocab/NoC-CR/1.0' => { images: ['NoC-CR-1.0.svg'], text: 'The University of Minnesota believes that this Item is not restricted by copyright and/or related rights. As part of the acquisition or digitization of this Work, the University of Minnesota is contractually required to limit the use of this Item. Limitations may include, but are not limited to, privacy issues, cultural protections, digitization agreements or donor agreements. For more information, contact us.' },
      'http://rightsstatements.org/vocab/NoC-NC/1.0' => { images: ['NoC-NC-1.0.svg'], text: 'The University of Minnesota has digitized this work in a public-private partnership. As part of this partnership, the partners have agreed to limit commercial uses of this digital representation of the Work by third parties. You can, without permission, copy, modify, distribute, display, or perform the Item, for non-commercial uses. For any other permissible uses, please contact us.' },
      'http://rightsstatements.org/vocab/NoC-OKLR/1.0' => { images: ['NoC-OKLR-1.0.svg'], text: 'The University of Minnesota believes that this Item is not restricted by copyright and/or related rights. In one or more jurisdictions, laws other than copyright are known to impose restrictions on the use of this Item. For more information, contact us.' },
      'http://rightsstatements.org/vocab/NoC-US/1.0' => { images: ['NoC-US-1.0.svg'], text: 'The University of Minnesota believes that this item is in the Public Domain under the laws of the United States, but did not make a determination as to its copyright status under the copyright laws of other countries. The item may not be in the Public Domain under the laws of other countries.' },
      'http://rightsstatements.org/vocab/UND/1.0' => { images: ['UND-1.0.svg.svg'], text: 'The University of Minnesota has reviewed the copyright and related rights status of this item, but was unable to make a conclusive determination as to the copyright status of the item. You are free to use this Item in any way that is permitted by the copyright and related rights legislation that applies to your use.' },
      'https://creativecommons.org/licenses/by-nc/4.0' => { images: ['cc_icon_white_x2.png', 'attribution_icon_white_x2.png', 'nc_white_x2.png'], text: 'This item is being shared with a Creative Commons license. You are free to share and adapt the item under the following conditions: you must give attribution or credit anytime you use it, and you may not use the item for commercial purposes (except as otherwise permitted by law.) For more details about this license, https://creativecommons.org/licenses/by-nc/4.0.' },
      'https://creativecommons.org/licenses/by/3.0' => { images: ['cc_icon_white_x2.png', 'attribution_icon_white_x2.png'], text: 'This item is being shared with a Creative Commons license. You are free to share and adapt the item under the following conditions: you must give attribution or credit anytime you use it. For more details about this license, https://creativecommons.org/licenses/by/3.0/.' }
    }
  end

  def rights_statement_uri
    rights_uri.chomp('/')
  end
end
