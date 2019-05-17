require_relative '../importers/base'

namespace :import do
  desc 'Import card sets data.'
  task :sets, %i[base_url] => %i[environment] do |_, args|
    Importers::CardSetsImporter.new(args).import!
  end

  desc 'Import card data for sets.'
  task :cards, %i[set] => %i[environment] do |_, args|
    ([args[:set]].compact + args.extras).each do |set_code|
      Importers::CardsImporter.new(set_code.upcase).import!
    end
  end

  desc 'Clear the set data cache.'
  task clear_cache: :environment do
    FileUtils.rm_rf(Importers::Base.cache_directory_path)
  end
end
