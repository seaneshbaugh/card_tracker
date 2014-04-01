namespace :import do
  # This task imports set symbol SVG files from BaconCatBug's symbol pack, found here:
  # http://www.mediafire.com/folder/92vnddvuu7ian/BaconCatBug's_SVG_Expansion_Symbol_Pack
  # The forum thread where it was originally posted can be found here:
  # http://www.mtgsalvation.com/forums/creativity/artwork/494438-baconcatbugs-set-and-mana-symbol-megapack
  # This task takes as its only argument the path of the root of the symbol pack, e.g.
  # rake import:set_symbols["/Users/seshbaugh/Downloads/BaconCatBug's Set Symbol Megapack - SVG - 25 Oct 2013/"]
  desc 'Import set symbol SVG files.'
  task :set_symbols, [:path] => [:environment] do |_, args|
    path = File.expand_path(File.join(args[:path], '2 - Modern Style - SVG'))

    name_map = {
      'Ajani vs Nicol Bolas' => 'ddh',
      'Alara Reborn' => 'arb',
      'Alliances' => 'all',
      'Alpha' => 'lea',
      'Anthologies' => 'ant',
      'Antiquities' => 'atq',
      'Apocalypse' => 'apc',
      'Arabian Nights' => 'arn',
      'Archenemy' => 'arc',
      'Avacyn Restored' => 'avr',
      'Battle Royale' => 'brb',
      'Beatdown' => 'btd',
      'Beta' => 'leb',
      'Betrayers of Kamigawa' => 'bok',
      'Born of the Gods' => 'bng',
      'Champions of Kamigawa' => 'chk',
      'Chronicles' => 'chr',
      'Coldsnap' => 'csp',
      'Commander' => 'cmd',
      'Commander 2013' => 'c13',
      "Commander's Arsenal" => 'cm1',
      'Conflux' => 'con',
      'Conspiracy' => 'cns',
      'Dark Ascension' => 'dka',
      'Darksteel' => 'dst',
      'Deckmasters' => 'dkm',
      'Dissension' => 'dis',
      'Divine vs Demonic' => 'ddc',
      "Dragon's Maze" => 'dgm',
      'Eighth Edition' => '8ed',
      'Elspeth vs Tezzeret' => 'ddf',
      'Elves vs Goblins' => 'evg',
      'Eventide' => 'eve',
      'Exodus' => 'exo',
      'Fallen Empires' => 'fem',
      'Fifth Dawn' => '5dn',
      'Fifth Edition' => '5ed',
      'Fourth Edition' => '4ed',
      'From the Vault Dragons' => 'drb',
      'From the Vault Exiled' => 'v09',
      'From the Vault Legends' => 'v10',
      'From the Vault Realms' => 'v11',
      'From the Vault Relics' => 'v12',
      'From the Vault Twenty' => 'v13',
      'Future Sight' => 'fut',
      'Garruk vs Liliana' => 'ddd',
      'Gatecrash' => 'gtc',
      'Guildpact' => 'gpt',
      'Heroes vs Monsters' => 'ddl',
      'Homelands' => 'hml',
      'Ice Age' => 'ice',
      'Innistrad' => 'isd',
      'Invasion' => 'inv',
      'Izzet vs Golgari' => 'ddj',
      'Jace vs Chandra' => 'dd2',
      'Jace vs Vraska' => 'ddm',
      'Journey into Nyx' => 'jou',
      'Judgement' => 'jud',
      'Knights vs Dragons' => 'ddg',
      'Legends' => 'leg',
      'Legions' => 'lgn',
      'Lorwyn' => 'lrw',
      'Magic 2010' => 'm10',
      'Magic 2011' => 'm11',
      'Magic 2012' => 'm12',
      'Magic 2013' => 'm13',
      'Magic 2014' => 'm14',
      'Magic 2015' => 'm15',
      'Masters Edition I' => 'med',
      'Masters Edition II' => 'me2',
      'Masters Edition III' => 'me3',
      'Masters Edition IV' => 'me4',
      'Mercadian Masques' => 'mmq',
      'Mirage' => 'mir',
      'Mirrodin' => 'mrd',
      'Mirrodin Besieged' => 'mbs',
      'Modern Masters' => 'mma',
      'Morningtide' => 'mor',
      'Nemesis' => 'nms',
      'New Phyrexia' => 'nph',
      'Ninth Edition' => '9ed',
      'Odyssey' => 'ody',
      'Onslaught' => 'ons',
      'Phyrexia vs The Coalition' => 'dde',
      'Planar Chaos' => 'plc',
      'Planechase' => 'hop',
      'Planechase 2012' => 'pc2',
      'Planeshift' => 'pls',
      'Portal' => 'por',
      'Portal Second Age' => 'p02',
      'Portal Three Kingdoms' => 'ptk',
      'Premium Deck Series Fire & Lightning' => 'pd2',
      'Premium Deck Series Graveborn' => 'pd3',
      'Premium Deck Series Slivers' => 'h09',
      'Prophecy' => 'pcy',
      'Ravnica' => 'rav',
      'Return to Ravnica' => 'rtr',
      'Revised' => '3ed',
      'Rise of the Eldrazi' => 'roe',
      'Saviors of Kamigawa' => 'sok',
      'Scars of Mirrodin' => 'som',
      'Scourge' => 'scg',
      'Seventh Edition' => '7ed',
      'Shadowmoor' => 'shm',
      'Shards of Alara' => 'ala',
      'Sixth Edition Classic' => '6ed',
      'Sorin vs Tibalt' => 'ddk',
      'Starter 1999' => 's99',
      'Starter 2000' => 's00',
      'Stronghold' => 'sth',
      'Tempest' => 'tmp',
      'Tenth Edition' => '10e',
      'The Dark' => 'drk',
      'Theros' => 'ths',
      'Time Spiral' => 'tsp',
      'Time Spiral Timeshifted' => 'tsb',
      'Torment' => 'tor',
      'Unglued' => 'ugl',
      'Unhinged' => 'unh',
      'Unlimited' => '2ed',
      "Urza's Destiny" => 'uds',
      "Urza's Legacy" => 'ulg',
      "Urza's Saga" => 'usg',
      'Venser vs Koth' => 'ddi',
      'Visions' => 'vis',
      'Weatherlight' => 'wth',
      'Worldwake' => 'wwk',
      'Zendikar' => 'zen'
    }

    files = Dir.glob(File.join(path, '**/*.svg'))

    files.each do |file|
      parts = File.basename(file, '.*').split('-')

      set_code = name_map[parts[1].strip]

      if set_code.present?
        rarity = parts[2].strip.first.downcase

        FileUtils.cp(file, Rails.root.join('app', 'assets', 'images', 'sets', "#{set_code}-#{rarity}.svg"))
      end
    end
  end

  # Same as above but for mana symbols.
  desc 'Import mana symbol SVG files.'
  task :mana_symbols, [:path] => [:environment] do |_, args|
    path = File.expand_path(File.join(args[:path], '4 - Mana and Other Symbols - SVG'))

    name_map = {
       'White' => 'w',
       'Blue' => 'u',
       'Black' => 'b',
       'Red' => 'r',
       'Green' => 'g',
       'Snow' => 's',
       'Zero' => '0',
       'One' => '1',
       'Two' => '2',
       'Three' => '3',
       'Four' => '4',
       'Five' => '5',
       'Six' => '6',
       'Seven' => '7',
       'Eight' => '8',
       'Nine' => '9',
       'Ten' => '10',
       'Eleven' => '11',
       'Twelve' => '12',
       'Thirteen' => '13',
       'Fourteen' => '14',
       'Fifteen' => '15',
       'Sixteen' => '16',
       'Seventeen' => '17',
       'Eighteen' => '18',
       'Nineteen' => '19',
       'Twenty' => '20',
       'X' => 'x',
       'Y' => 'y',
       'Z' => 'z',
       'White or Blue' => 'wu',
       'White or Black' => 'wb',
       'Blue or Black' => 'ub',
       'Blue or Red' => 'ur',
       'Black or Red' => 'br',
       'Black or Green' => 'bg',
       'Red or White' => 'rw',
       'Red or Green' => 'rg',
       'Green or White' => 'gw',
       'Green or Blue' => 'gu',
       '2 Colorless or White' => '2w',
       '2 Colorless or Blue' => '2u',
       '2 Colorless or Black' => '2b',
       '2 Colorless or Red' => '2r',
       '2 Colorless or Green' => '2g',
       'Phyrexian White' => 'pw',
       'Phyrexian Blue' => 'pu',
       'Phyrexian Black' => 'pb',
       'Phyrexian Red' => 'pr',
       'Phyrexian Green' => 'pg',
       'Phyrexian Colorless' => 'p',
       'Tap Symbol Post 8th Edition' => 't',
       'Untap Symbol Post 8th Edition' => 'q',
       'Half White' => 'hw',
       'Half Blue' => 'hu',
       'Half Black' => 'hb',
       'Half Red' => 'hr',
       'Half Green' => 'hg',
       'Half Colorless' => 'h',
       'Infinity' => 'i',
       'One Hundred' => '100',
       'One Million' => '1000000',
       'Chaos Dice' => 'c'
    }

    [File.join(path, 'A - Colored Mana'),
     File.join(path, 'B - Colorless Mana'),
     File.join(path, 'C - Hybrid Mana'),
     File.join(path, 'D - Phyrexian Mana'),
     File.join(path, 'E - Tap Symbols'),
     File.join(path, 'X - Miscellaneous Symbols')].each do |directory|
      files = Dir.glob(File.join(directory, '*.svg'))

      files.each do |file|
        mapped_name = name_map[File.basename(file, '.*').gsub('Phyrexian Mana - ', 'Phyrexian ').gsub('Tap Symbol - ', 'Tap Symbol ').gsub('Untap Symbol - ', 'Untap Symbol ').gsub('Half Mana - ', 'Half ').split('-').last.strip]

        if mapped_name.present?
          FileUtils.cp(file, Rails.root.join('app', 'assets', 'images', 'symbols', "#{mapped_name}.svg"))
        end
      end
    end
  end

  desc 'Import card data.'
  task :cards, [:set] => [:environment] do |_, args|
    set_codes = ([args[:set]].compact + args.extras).map { |set_code| set_code.upcase }

    set_codes.each do |set_code|
      cached_file_path = Rails.root.join('tmp', 'set_data', "#{set_code}.json")

      unless File.exist?(cached_file_path)
        agent = Mechanize.new

        response = agent.get("http://mtgjson.com/json/#{set_code}.json")

        if response.code == '200'
          FileUtils.mkdir_p(File.dirname(cached_file_path))

          cached_file = File.new(cached_file_path, 'w')

          cached_file.puts response.body

          cached_file.close
        else
          puts raise "Could not retrieve http://mtgjson.com/json/#{set_code}.json. Got error code #{response.code}."
        end
      end

      imported_cards = JSON.parse(File.read(cached_file_path))['cards']

      card_set = CardSet.where(:code => set_code).includes(:cards).first

      raise "Card set with code #{set_code} not found." unless card_set.present?

      puts "Importing cards for #{card_set.name}(#{card_set.code})."

      cards = card_set.cards

      if imported_cards.length != cards.length
        puts "Warning: #{card_set.name} cards length does not match imported length."
      end

      def create_or_update_card(imported_card, card, card_set)
        colors = (imported_card['colors'] || []).join(';')

        card_supertypes = (imported_card['supertypes'] || []).join(';')

        card_types = (imported_card['types'] || []).join(';')

        card_subtypes = (imported_card['subtypes'] || []).join(';')

        if card.present?
          if card.update_attributes({
                                      :name => imported_card['name'].to_s,
                                      :layout => imported_card['layout'].to_s,
                                      :mana_cost => imported_card['manaCost'].to_s,
                                      :converted_mana_cost => imported_card['cmc'].to_s,
                                      :colors => colors,
                                      :card_type => imported_card['type'].to_s,
                                      :card_supertypes => card_supertypes,
                                      :card_types => card_types,
                                      :card_subtypes => card_subtypes,
                                      :card_text => imported_card['text'].to_s.gsub("\n", '<br>'),
                                      :flavor_text => imported_card['flavor'].to_s.gsub("\n", '<br>'),
                                      :power => imported_card['power'].to_s,
                                      :toughness => imported_card['toughness'].to_s,
                                      :loyalty => imported_card['loyalty'].to_s,
                                      :rarity => imported_card['rarity'].to_s,
                                      :card_number => imported_card['number'].to_s,
                                      :artist => imported_card['artist'].to_s
                                    })
            puts "Updated existing card #{card.id} #{card.name}(#{card.multiverse_id})."
          else
            puts "Failed to update existing card #{card.name}(#{card.multiverse_id}). #{card.errors.full_messages.join('. ')}."
          end
        else
          card = Card.new({
                            :multiverse_id => imported_card['multiverseid'].to_s,
                            :name => imported_card['name'].to_s,
                            :card_set_id => card_set.id,
                            :layout => imported_card['layout'].to_s,
                            :mana_cost => imported_card['manaCost'].to_s,
                            :converted_mana_cost => imported_card['cmc'].to_s,
                            :colors => colors,
                            :card_type => imported_card['type'].to_s,
                            :card_supertypes => card_supertypes,
                            :card_types => card_types,
                            :card_subtypes => card_subtypes,
                            :card_text => imported_card['text'].to_s.gsub("\n", '<br>'),
                            :flavor_text => imported_card['flavor'].to_s.gsub("\n", '<br>'),
                            :power => imported_card['power'].to_s,
                            :toughness => imported_card['toughness'].to_s,
                            :loyalty => imported_card['loyalty'].to_s,
                            :rarity => imported_card['rarity'].to_s,
                            :card_number => imported_card['number'].to_s,
                            :artist => imported_card['artist'].to_s
                          })

          if card.save
            puts "Created new card #{card.name}(#{card.multiverse_id})."
          else
            puts "Failed to create new card #{card.name}(#{card.multiverse_id}). #{card.errors.full_messages.join('. ')}."
          end
        end

        card
      end

      imported_cards.select { |imported_card| %w(normal plane scheme phenomenon).include? imported_card['layout'] }.each do |imported_card|
        card = cards.select { |card| card.multiverse_id == imported_card['multiverseid'].to_s }.first

        create_or_update_card(imported_card, card, card_set)
      end

      imported_cards.select { |imported_card| imported_card['layout'] == 'split' }.group_by { |imported_card| imported_card['multiverseid'] }.each do |_, imported_card_parts|
        card_name = imported_card_parts.first['names'].join(' // ')

        colors = imported_card_parts.inject([]) { |colors, imported_card_part| colors + (imported_card_part['colors'] || []) }.uniq

        card_supertypes = imported_card_parts.inject([]) { |supertypes, imported_card_part| supertypes + (imported_card_part['supertypes'] || []) }.uniq

        card_types = imported_card_parts.inject([]) { |types, imported_card_part| types + (imported_card_part['types'] || []) }.uniq

        card_subtypes = imported_card_parts.inject([]) { |subtypes, imported_card_part| subtypes + (imported_card_part['subtypes'] || []) }.uniq

        card_number = imported_card_parts.first['number'].gsub(/\D/, '')

        card = cards.select { |card| card.name == card_name }.first

        imported_card = {
          'multiverseid' => imported_card_parts.first['multiverseid'],
          'name' => card_name,
          'layout' => 'split',
          'manaCost' => '',
          'cmc' => '',
          'colors' => colors,
          'card_type' => '',
          'supertypes' => card_supertypes,
          'types' => card_types,
          'subtypes' => card_subtypes,
          'text' => '',
          'flavor' => '',
          'power' => '',
          'toughness' => '',
          'loyalty' => '',
          'rarity' => imported_card_parts.first['rarity'],
          'number' => card_number,
          'artist' => ''
        }

        card = create_or_update_card(imported_card, card, card_set)

        imported_card_parts.each do |imported_card_part|
          card_part = card.card_parts.select { |card_part| imported_card_part['name'] == card_part.name }.first

          colors = (imported_card_part['colors'] || []).join(';')

          card_supertypes = (imported_card_part['supertypes'] || []).join(';')

          card_types = (imported_card_part['types'] || []).join(';')

          card_subtypes = (imported_card_part['subtypes'] || []).join(';')

          if card_part.present?
            if card_part.update_attributes({
                                        :name => imported_card_part['name'].to_s,
                                        :layout => 'split',
                                        :mana_cost => imported_card_part['manaCost'].to_s,
                                        :converted_mana_cost => imported_card_part['cmc'].to_s,
                                        :colors => colors,
                                        :card_type => imported_card_part['type'].to_s,
                                        :card_supertypes => card_supertypes,
                                        :card_types => card_types,
                                        :card_subtypes => card_subtypes,
                                        :card_text => imported_card_part['text'].to_s.gsub("\n", '<br>'),
                                        :flavor_text => imported_card_part['flavor'].to_s.gsub("\n", '<br>'),
                                        :power => imported_card_part['power'].to_s,
                                        :toughness => imported_card_part['toughness'].to_s,
                                        :loyalty => imported_card_part['loyalty'].to_s,
                                        :rarity => imported_card_part['rarity'].to_s,
                                        :card_number => imported_card_part['number'].to_s,
                                        :artist => imported_card_part['artist'].to_s
                                      })
              puts "Updated existing card part #{card_part.id} #{card_part.name}(#{card_part.multiverse_id})."
            else
              puts "Failed to update existing card part #{card_part.name}(#{card_part.multiverse_id}). #{card_part.errors.full_messages.join('. ')}."
            end
          else
            card_part = CardPart.new({
                                  :multiverse_id => imported_card_part['multiverseid'].to_s,
                                  :name => imported_card_part['name'].to_s,
                                  :card_id => card.id,
                                  :layout => 'split',
                                  :mana_cost => imported_card_part['manaCost'].to_s,
                                  :converted_mana_cost => imported_card_part['cmc'].to_s,
                                  :colors => colors,
                                  :card_type => imported_card_part['type'].to_s,
                                  :card_supertypes => card_supertypes,
                                  :card_types => card_types,
                                  :card_subtypes => card_subtypes,
                                  :card_text => imported_card_part['text'].to_s.gsub("\n", '<br>'),
                                  :flavor_text => imported_card_part['flavor'].to_s.gsub("\n", '<br>'),
                                  :power => imported_card_part['power'].to_s,
                                  :toughness => imported_card_part['toughness'].to_s,
                                  :loyalty => imported_card_part['loyalty'].to_s,
                                  :rarity => imported_card_part['rarity'].to_s,
                                  :card_number => imported_card_part['number'].to_s,
                                  :artist => imported_card_part['artist'].to_s
                                })

            if card_part.save
              puts "Created new card part #{card_part.name}(#{card_part.multiverse_id})."
            else
              puts "Failed to create new card part #{card_part.name}(#{card_part.multiverse_id}). #{card_part.errors.full_messages.join('. ')}."
            end
          end
        end
      end

      imported_cards.select { |imported_card| imported_card['layout'] == 'flip' }.group_by { |imported_card| imported_card['multiverseid'] }.each do |_, imported_card_parts|
        card_name = imported_card_parts.first['names'].first

        colors = ((imported_card_parts.first['colors'] || []) + (imported_card_parts.last['colors'] || [])).uniq

        card_supertypes = ((imported_card_parts.first['supertypes'] || []) + (imported_card_parts.last['supertypes'] || [])).uniq

        card_types = ((imported_card_parts.first['types'] || []) + (imported_card_parts.last['types'] || [])).uniq

        card_subtypes = ((imported_card_parts.first['subtypes'] || []) + (imported_card_parts.last['subtypes'] || [])).uniq

        card_number = imported_card_parts.first['number'].gsub(/\D/, '')

        card = cards.select { |card| card.name == card_name }.first

        imported_card = {
          'multiverseid' => imported_card_parts.first['multiverseid'],
          'name' => card_name,
          'layout' => imported_card_parts.first['layout'],
          'manaCost' => '',
          'cmc' => '',
          'colors' => colors,
          'card_type' => '',
          'supertypes' => card_supertypes,
          'types' => card_types,
          'subtypes' => card_subtypes,
          'text' => '',
          'flavor' => '',
          'power' => '',
          'toughness' => '',
          'loyalty' => '',
          'rarity' => imported_card_parts.first['rarity'],
          'number' => card_number,
          'artist' => ''
        }

        card = create_or_update_card(imported_card, card, card_set)

        imported_card_parts.each do |imported_card_part|
          card_part = card.card_parts.select { |card_part| imported_card_part['name'] == card_part.name }.first

          colors = (imported_card_part['colors'] || []).join(';')

          card_supertypes = (imported_card_part['supertypes'] || []).join(';')

          card_types = (imported_card_part['types'] || []).join(';')

          card_subtypes = (imported_card_part['subtypes'] || []).join(';')

          if card_part.present?
            if card_part.update_attributes({
                                             :name => imported_card_part['name'].to_s,
                                             :layout => imported_card_part['layout'].to_s,
                                             :mana_cost => imported_card_part['manaCost'].to_s,
                                             :converted_mana_cost => imported_card_part['cmc'].to_s,
                                             :colors => colors,
                                             :card_type => imported_card_part['type'].to_s,
                                             :card_supertypes => card_supertypes,
                                             :card_types => card_types,
                                             :card_subtypes => card_subtypes,
                                             :card_text => imported_card_part['text'].to_s.gsub("\n", '<br>'),
                                             :flavor_text => imported_card_part['flavor'].to_s.gsub("\n", '<br>'),
                                             :power => imported_card_part['power'].to_s,
                                             :toughness => imported_card_part['toughness'].to_s,
                                             :loyalty => imported_card_part['loyalty'].to_s,
                                             :rarity => imported_card_part['rarity'].to_s,
                                             :card_number => imported_card_part['number'].to_s,
                                             :artist => imported_card_part['artist'].to_s
                                           })
              puts "Updated existing card part #{card_part.id} #{card_part.name}(#{card_part.multiverse_id})."
            else
              puts "Failed to update existing card part #{card_part.name}(#{card_part.multiverse_id}). #{card_part.errors.full_messages.join('. ')}."
            end
          else
            card_part = CardPart.new({
                                       :multiverse_id => imported_card_part['multiverseid'].to_s,
                                       :name => imported_card_part['name'].to_s,
                                       :card_id => card.id,
                                       :layout => imported_card_part['layout'].to_s,
                                       :mana_cost => imported_card_part['manaCost'].to_s,
                                       :converted_mana_cost => imported_card_part['cmc'].to_s,
                                       :colors => colors,
                                       :card_type => imported_card_part['type'].to_s,
                                       :card_supertypes => card_supertypes,
                                       :card_types => card_types,
                                       :card_subtypes => card_subtypes,
                                       :card_text => imported_card_part['text'].to_s.gsub("\n", '<br>'),
                                       :flavor_text => imported_card_part['flavor'].to_s.gsub("\n", '<br>'),
                                       :power => imported_card_part['power'].to_s,
                                       :toughness => imported_card_part['toughness'].to_s,
                                       :loyalty => imported_card_part['loyalty'].to_s,
                                       :rarity => imported_card_part['rarity'].to_s,
                                       :card_number => imported_card_part['number'].to_s,
                                       :artist => imported_card_part['artist'].to_s
                                     })

            if card_part.save
              puts "Created new card part #{card_part.name}(#{card_part.multiverse_id})."
            else
              puts "Failed to create new card part #{card_part.name}(#{card_part.multiverse_id}). #{card_part.errors.full_messages.join('. ')}."
            end
          end
        end
      end

      imported_cards.select { |imported_card| imported_card['layout'] == 'double-faced' }.group_by { |imported_card| imported_card['names'] }.each do |_, imported_card_parts|
        card_name = imported_card_parts.first['names'].first

        colors = ((imported_card_parts.first['colors'] || []) + (imported_card_parts.last['colors'] || [])).uniq

        card_supertypes = ((imported_card_parts.first['supertypes'] || []) + (imported_card_parts.last['supertypes'] || [])).uniq

        card_types = ((imported_card_parts.first['types'] || []) + (imported_card_parts.last['types'] || [])).uniq

        card_subtypes = ((imported_card_parts.first['subtypes'] || []) + (imported_card_parts.last['subtypes'] || [])).uniq

        card_number = imported_card_parts.first['number'].gsub(/\D/, '')

        card = cards.select { |card| card.name == card_name }.first

        imported_card = {
          'multiverseid' => imported_card_parts.first['multiverseid'],
          'name' => card_name,
          'layout' => imported_card_parts.first['layout'],
          'manaCost' => '',
          'cmc' => '',
          'colors' => colors,
          'card_type' => '',
          'supertypes' => card_supertypes,
          'types' => card_types,
          'subtypes' => card_subtypes,
          'text' => '',
          'flavor' => '',
          'power' => '',
          'toughness' => '',
          'loyalty' => '',
          'rarity' => imported_card_parts.first['rarity'],
          'number' => card_number,
          'artist' => ''
        }

        card = create_or_update_card(imported_card, card, card_set)

        imported_card_parts.each do |imported_card_part|
          card_part = card.card_parts.select { |card_part| imported_card_part['name'] == card_part.name }.first

          colors = (imported_card_part['colors'] || []).join(';')

          card_supertypes = (imported_card_part['supertypes'] || []).join(';')

          card_types = (imported_card_part['types'] || []).join(';')

          card_subtypes = (imported_card_part['subtypes'] || []).join(';')

          if card_part.present?
            if card_part.update_attributes({
                                             :name => imported_card_part['name'].to_s,
                                             :layout => imported_card_part['layout'].to_s,
                                             :mana_cost => imported_card_part['manaCost'].to_s,
                                             :converted_mana_cost => imported_card_part['cmc'].to_s,
                                             :colors => colors,
                                             :card_type => imported_card_part['type'].to_s,
                                             :card_supertypes => card_supertypes,
                                             :card_types => card_types,
                                             :card_subtypes => card_subtypes,
                                             :card_text => imported_card_part['text'].to_s.gsub("\n", '<br>'),
                                             :flavor_text => imported_card_part['flavor'].to_s.gsub("\n", '<br>'),
                                             :power => imported_card_part['power'].to_s,
                                             :toughness => imported_card_part['toughness'].to_s,
                                             :loyalty => imported_card_part['loyalty'].to_s,
                                             :rarity => imported_card_part['rarity'].to_s,
                                             :card_number => imported_card_part['number'].to_s,
                                             :artist => imported_card_part['artist'].to_s
                                           })
              puts "Updated existing card part #{card_part.id} #{card_part.name}(#{card_part.multiverse_id})."
            else
              puts "Failed to update existing card part #{card_part.name}(#{card_part.multiverse_id}). #{card_part.errors.full_messages.join('. ')}."
            end
          else
            card_part = CardPart.new({
                                       :multiverse_id => imported_card_part['multiverseid'].to_s,
                                       :name => imported_card_part['name'].to_s,
                                       :card_id => card.id,
                                       :layout => imported_card_part['layout'].to_s,
                                       :mana_cost => imported_card_part['manaCost'].to_s,
                                       :converted_mana_cost => imported_card_part['cmc'].to_s,
                                       :colors => colors,
                                       :card_type => imported_card_part['type'].to_s,
                                       :card_supertypes => card_supertypes,
                                       :card_types => card_types,
                                       :card_subtypes => card_subtypes,
                                       :card_text => imported_card_part['text'].to_s.gsub("\n", '<br>'),
                                       :flavor_text => imported_card_part['flavor'].to_s.gsub("\n", '<br>'),
                                       :power => imported_card_part['power'].to_s,
                                       :toughness => imported_card_part['toughness'].to_s,
                                       :loyalty => imported_card_part['loyalty'].to_s,
                                       :rarity => imported_card_part['rarity'].to_s,
                                       :card_number => imported_card_part['number'].to_s,
                                       :artist => imported_card_part['artist'].to_s
                                     })

            if card_part.save
              puts "Created new card part #{card_part.name}(#{card_part.multiverse_id})."
            else
              puts "Failed to create new card part #{card_part.name}(#{card_part.multiverse_id}). #{card_part.errors.full_messages.join('. ')}."
            end
          end
        end
      end

      imported_cards.select { |imported_card| imported_card['layout'] == 'token' }.each do |imported_card|
        puts "Warning: Ignoring token card #{imported_card['name']}(#{imported_card['multiverseid']})."
      end
    end
  end

  desc 'Clear the set data cache.'
  task :clear_cache => :environment do
    FileUtils.rm_rf(Rails.root.join('tmp', 'set_data'))
  end
end
