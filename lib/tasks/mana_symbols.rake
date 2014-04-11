require 'shellwords'

namespace :mana_symbols do
  desc 'Make PNG files from imported SVG files.'
  task :make_pngs => :environment do
    files = Dir.glob(Rails.root.join('app', 'assets', 'images', 'symbols', '*.svg'))

    files.each do |file|
      { '-small' => 22, '' => 44, '-large' => 100, '-extra-large' => 250, '-full' => 500 }.each do |suffix, size|
        new_file = File.join(File.dirname(file), "#{File.basename(file, '.*')}#{suffix}.png")

        system("inkscape --export-png=#{Shellwords.escape(new_file)} --export-background-opacity=0 --export-height=#{size} --without-gui #{Shellwords.escape(file)} > /dev/null 2>&1")
      end
    end
  end

  desc 'Make spritesheet PNG files and accompanying LESS files.'
  task :make_spritesheets => :environment do
    template_file = Rails.root.join('lib', 'templates', 'erb', 'spritesheets', 'mana_symbols.less.erb')

    @results = {}

    ['small', '', 'large', 'extra-large', 'full'].each do |size|
      @results[size] = {}

      if size.present?
        size_name = "-#{size}"
      else
        size_name = ''
      end

      spritesheet_file = "mana-symbols#{size_name}-spritesheet.png"

      @results[size]['spritesheet'] = spritesheet_file

      files = Dir.glob(Rails.root.join('app', 'assets', 'images', 'symbols', "*#{size_name}.png"))

      if size.present?
        if size == 'large'
          files.reject! { |file| File.basename(file).include?('-extra-large.png') }
        end
      else
        files.reject! { |file| File.basename(file).index(/-small|-large|-extra-large|-full/) }
      end

      system("montage #{files.join(' ')} -background none -mode Concatenate -tile 5x #{Rails.root.join('app', 'assets', 'images', 'symbols', spritesheet_file)} > /dev/null 2>&1")

      @results[size]['symbols'] = {}

      y = 0

      files.each_slice(5) do |row|
        x = 0

        largest_height = 0

        row.each do |file|
          image = Magick::Image.read(file)

          symbol = file.split('/').last.split('-').first.split('.').first.downcase

          @results[size]['symbols'][symbol] = { :x1 => x, :y1 => y, :x2 => x + image[0].columns, :y2 => y + image[0].rows }

          x += image[0].columns

          if image[0].rows > largest_height
            largest_height = image[0].rows
          end
        end

        y += largest_height
      end
    end

    less_file = File.new(Rails.root.join('app', 'assets', 'stylesheets', 'application', 'mana_symbols.less'), 'w')

    less_file.puts ERB.new(File.read(template_file), 0, '>').result(binding)

    less_file.close
  end
end
