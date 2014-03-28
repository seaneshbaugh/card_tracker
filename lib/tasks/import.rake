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
       'White' => 'W',
       'Blue' => 'U',
       'Black' => 'B',
       'Red' => 'R',
       'Green' => 'G',
       'Snow' => 'snow',
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
       'X' => 'X',
       'Y' => 'Y',
       'Z' => 'Z',
       'White or Blue' => 'WU',
       'White or Black' => 'WB',
       'Blue or Black' => 'UB',
       'Blue or Red' => 'UR',
       'Black or Red' => 'BR',
       'Black or Green' => 'BG',
       'Red or White' => 'RW',
       'Red or Green' => 'RG',
       'Green or White' => 'GW',
       'Green or Blue' => 'GU',
       '2 Colorless or White' => '2W',
       '2 Colorless or Blue' => '2U',
       '2 Colorless or Black' => '2B',
       '2 Colorless or Red' => '2R',
       '2 Colorless or Green' => '2G',
       'Phyrexian White' => 'WP',
       'Phyrexian Blue' => 'UP',
       'Phyrexian Black' => 'BP',
       'Phyrexian Red' => 'RP',
       'Phyrexian Green' => 'GP',
       'Phyrexian Colorless' => 'CP',
       'Tap Symbol Post 8th Edition' => 'tap',
       'Untap Symbol Post 8th Edition' => 'untap',
       'Half White' => 'HalfW',
       'Half Blue' => 'HalfU',
       'Half Black' => 'HalfB',
       'Half Red' => 'HalfR',
       'Half Green' => 'HalfG',
       'Half Colorless' => 'Half',
       'Infinity' => 'I',
       'One Hundred' => '100',
       'One Million' => '1000000'
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
end
