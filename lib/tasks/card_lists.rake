namespace :card_lists do
  desc 'Create the default card lists for users who have no lists.'
  task :create_default_card_lists => :environment do
    users = User.includes(:card_lists)

    users.each do |user|
      user.create_default_lists

      user.save
    end
  end

  desc 'Add existing collections to the first card list a user has.'
  task :add_collections_to_card_list => :environment do
    users = User.includes(:card_lists, :collections)

    users.each do |user|
      user.create_default_lists

      user.save

      user.collections.each do |collection|
        collection.card_list_id = user.card_lists.sort_by(&:order).first.id

        collection.save
      end
    end
  end
end
