# frozen_string_literal: ture

require_relative '../attribute_mapper'

module Importers
  class Base
    extend Memoist

    DEFAULT_BASE_URL = 'https://mtgjson.com/json/'

    attr_reader :agent
    attr_reader :base_url

    def initialize(options = {})
      @agent = Mechanize.new
      @base_url = options.delete(:base_url) || DEFAULT_BASE_URL
    end

    def import!
      raise NotImplementedError
    end

    private

    def cache_file(file_name, contents)
      file_path = cache_file_path(file_name)

      FileUtils.mkdir_p(File.dirname(file_path))

      File.open(file_path, 'w') do |file|
        file.write(contents)
      end

      contents
    end

    def cache_file_path(file_name)
      Rails.root.join('tmp', 'import_data', Time.current.strftime('%Y-%m'), file_name)
    end
    memoize :cache_file_path

    def download_and_parse_file(file_name)
      JSON.parse(download_file(file_name))
    end

    def download_file(file_name)
      cache_file_contents = read_cache_file(file_name)

      puts "Using cached copy of #{file_name.inspect}." if cache_file_contents

      return cache_file_contents if cache_file_contents

      puts "Downloading #{file_name.inspect}."

      response = agent.get(file_url(file_name))

      response.body.force_encoding(Encoding.find('UTF-8'))

      puts "Downloaded #{file_name.inspect}."

      cache_file(file_name, response.body)
    end

    def file_url(file_name)
      "#{base_url}#{file_name}"
    end

    def read_cache_file(file_name)
      file_path = cache_file_path(file_name)

      return unless File.exist?(file_path)

      File.read(file_path)
    end
  end
end

require_relative './card_sets_importer'
require_relative './cards_importer'
