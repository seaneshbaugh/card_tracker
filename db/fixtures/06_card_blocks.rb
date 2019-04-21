# frozen_string_literal: true

# TODO: Remove CardBlockType from this. See note in CardBlockType class file.
expansion = CardBlockType.find_by!(name: 'Expansion')

CardBlock.seed(:id) do |s|
  s.card_block_type = expansion
  s.name = "Ice Age"
end

CardBlock.seed(:id) do |s|
  s.card_block_type = expansion
  s.name = "Mirage"
end

CardBlock.seed(:id) do |s|
  s.card_block_type = expansion
  s.name = "Rath"
end

CardBlock.seed(:id) do |s|
  s.card_block_type = expansion
  s.name = "Artifacts"
end

CardBlock.seed(:id) do |s|
  s.card_block_type = expansion
  s.name = "Masquerade"
end

CardBlock.seed(:id) do |s|
  s.card_block_type = expansion
  s.name = "Invasion"
end

CardBlock.seed(:id) do |s|
  s.card_block_type = expansion
  s.name = "Odyssey"
end

CardBlock.seed(:id) do |s|
  s.card_block_type = expansion
  s.name = "Onslaught"
end

CardBlock.seed(:id) do |s|
  s.card_block_type = expansion
  s.name = "Mirrodin"
end

CardBlock.seed(:id) do |s|
  s.card_block_type = expansion
  s.name = "Kamigawa"
end

CardBlock.seed(:id) do |s|
  s.card_block_type = expansion
  s.name = "Ravnica"
end

CardBlock.seed(:id) do |s|
  s.card_block_type = expansion
  s.name = "Time Spiral"
end

CardBlock.seed(:id) do |s|
  s.card_block_type = expansion
  s.name = "Lorwyn"
end

CardBlock.seed(:id) do |s|
  s.card_block_type = expansion
  s.name = "Shadowmoor"
end

CardBlock.seed(:id) do |s|
  s.card_block_type = expansion
  s.name = "Alara"
end

CardBlock.seed(:id) do |s|
  s.card_block_type = expansion
  s.name = "Zendikar"
end

CardBlock.seed(:id) do |s|
  s.card_block_type = expansion
  s.name = "Scars of Mirrodin"
end

CardBlock.seed(:id) do |s|
  s.card_block_type = expansion
  s.name = "Innistrad"
end

CardBlock.seed(:id) do |s|
  s.card_block_type = expansion
  s.name = "Return to Ravnica"
end

CardBlock.seed(:id) do |s|
  s.card_block_type = expansion
  s.name = "Theros"
end

CardBlock.seed(:id) do |s|
  s.card_block_type = expansion
  s.name = "Khans of Tarkir"
end

CardBlock.seed(:id) do |s|
  s.card_block_type = expansion
  s.name = "Battle of Zendikar"
end

CardBlock.seed(:id) do |s|
  s.card_block_type = expansion
  s.name = "Shadows over Innistrad"
end

CardBlock.seed(:id) do |s|
  s.card_block_type = expansion
  s.name = "Kaladesh"
end

CardBlock.seed(:id) do |s|
  s.card_block_type = expansion
  s.name = "Amonkhet"
end

CardBlock.seed(:id) do |s|
  s.card_block_type = expansion
  s.name = "Ixalan"
end
