# frozen_string_literal: true

Rarity.seed(:rarity_code) do |s|
  s.rarity_code = 'B'
  s.name = 'Basic'
end

Rarity.seed(:rarity_code) do |s|
  s.rarity_code = 'C'
  s.name = 'Common'
end

Rarity.seed(:rarity_code) do |s|
  s.rarity_code = 'U'
  s.name = 'Uncommon'
end

Rarity.seed(:rarity_code) do |s|
  s.rarity_code = 'R'
  s.name = 'Rare'
end

Rarity.seed(:rarity_code) do |s|
  s.rarity_code = 'M'
  s.name = 'Mythic'
end
