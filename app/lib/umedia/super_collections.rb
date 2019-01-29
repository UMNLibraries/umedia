module Umedia
  class SuperCollections
    def names
      config.map { |config| config[:name] }
    end

    def item_ids_for(name)
      config.select { |collection| collection[:name] == name }
            .map { |config| config[:item_ids] }
    end

    def config
      [
        { name: "Exploring Minnesota's Natural History", item_ids: ['p16022coll174:731', 'p16022coll174:3367', 'p16022coll174:2812'] },
        { name: "Revealing Bound Maps", item_ids: ['p16022coll251:844', 'p16022coll251:670', 'p16022coll243:22'] },
        { name: "Minnesota's Radio History", item_ids: ['p16022coll171:1222', 'p16022coll171:2119', 'p16022coll171:2224'] },
        { name: "The Green Revolution", item_ids: ['p16022coll342:22911', 'p16022coll342:2711', 'p16022coll342:48664'] },
        { name: "African American Archival Materials", item_ids: ['p16022coll391:1685', 'p16022coll413:1', 'p16022coll354:3514'] }
      ]
    end
  end
end