# frozen_string_literal: true

module Umedia
  # Stand-in for a real data model. Since this changes rarely, we're starrting
  # off with a simple class to hold supercollection config data
  class SuperCollections
    def names
      config.map { |config| config[:name] }
    end

    def item_ids_for(name)
      config.select { |collection| collection[:name] == name }
            .map { |config| config[:item_ids] }.flatten
    end

    def config
      [
        { name: "Exploring Minnesota's Natural History", item_ids: ['p16022coll349:8804', 'p16022coll243:1386', 'p16022coll174:3318'] },
        { name: "Revealing Bound Maps", item_ids: ['p16022coll251:1227', 'p16022coll251:1245', 'p16022coll251:5895'] },
        { name: "Minnesota's Radio History", item_ids: ['p16022coll171:1222', 'p16022coll171:2119', 'p16022coll171:2224'] },
        { name: "The Green Revolution", item_ids: ['p16022coll345:12027', 'p16022coll342:46679', 'p16022coll347:32763'] },
        { name: "African American Archival Materials", item_ids: ['p16022coll300:83', 'p16022coll226:107', 'p16022coll317:364'] },
        { name: "Seoul National University", item_ids: ['p16022coll175:20865', 'p16022coll175:20873', 'p16022coll175:20882'] },
        { name: "Atlantic World", item_ids: ['p16022coll460:496', 'p16022coll184:1854', 'p16022coll184:1348'] }
      ]
    end
  end
end