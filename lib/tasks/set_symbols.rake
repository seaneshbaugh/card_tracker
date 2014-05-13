require 'shellwords'

namespace :set_symbols do
  desc 'Copy the "Coming Soon" image to the set symbol directory as a placeholder.'
  task :coming_soon, [:set] => [:environment] do |_, args|
    sets = [args[:set]].compact + args.extras

    sets.each do |set|
      ['c', 'u', 'r', 'm'].each do |rarity|
        ['small', '', 'large', 'extra-large', 'full'].each do |size|
          if size.present?
            size_name = "-#{size}"
          else
            size_name = ''
          end

          FileUtils.cp(Rails.root.join('app', 'assets', 'images', "coming-soon#{size_name}.png"), Rails.root.join('app', 'assets', 'images', 'sets', "#{set.downcase}-#{rarity}#{size_name}.png"))
        end

        FileUtils.cp(Rails.root.join('app', 'assets', 'images', 'coming-soon.svg'), Rails.root.join('app', 'assets', 'images', 'sets', "#{set.downcase}-#{rarity}.svg"))
      end
    end
  end

  desc 'Make PNG files from imported SVG files.'
  task :make_pngs => :environment do
    files = Dir.glob(Rails.root.join('app', 'assets', 'images', 'sets', '*.svg'))

    files.each do |file|
      { '-small' => 22, '' => 44, '-large' => 100, '-extra-large' => 250, '-full' => 500 }.each do |suffix, size|
        new_file = File.join(File.dirname(file), "#{File.basename(file, '.*')}#{suffix}.png")

        system("inkscape --export-png=#{Shellwords.escape(new_file)} --export-background-opacity=0 --export-width=#{size} --without-gui #{Shellwords.escape(file)} > /dev/null 2>&1")
      end
    end
  end

  desc 'Make spritesheet PNG files and accompanying LESS files.'
  task :make_spritesheets => :environment do
    template_file = Rails.root.join('lib', 'templates', 'erb', 'spritesheets', 'set_symbols.less.erb')

    @results = {}

    ['small', '', 'large', 'extra-large', 'full'].each do |size|
      @results[size] = {}

      ['c', 'u', 'r', 'm'].each do |rarity|
        @results[size][rarity] = {}

        if size.present?
          size_name = "-#{size}"
        else
          size_name = ''
        end

        spritesheet_file = "#{rarity}#{size_name}-spritesheet.png"

        @results[size][rarity]['spritesheet'] = spritesheet_file

        files = Dir.glob(Rails.root.join('app', 'assets', 'images', 'sets', "*-#{rarity}#{size_name}.png"))

        if size.present?
          if size == 'large'
            files.reject! { |file| File.basename(file).include?('-extra-large.png') }
          end
        else
          files.reject! { |file| File.basename(file).index(/-small|-large|-extra-large|-full/) }
        end

        system("montage #{files.map { |file| Shellwords.escape(file) }.join(' ')} -background none -mode Concatenate -tile 5x #{Rails.root.join('app', 'assets', 'images', 'sets', spritesheet_file)} > /dev/null 2>&1")

        @results[size][rarity]['sets'] = {}

        y = 0

        files.each_slice(5) do |row|
          x = 0

          largest_height = 0

          row.each do |file|
            image = Magick::Image.read(file)

            set = file.split('/').last.split('-').first.downcase

            @results[size][rarity]['sets'][set] = { :x1 => x, :y1 => y, :x2 => x + image[0].columns, :y2 => y + image[0].rows }

            x += image[0].columns

            if image[0].rows > largest_height
              largest_height = image[0].rows
            end
          end

          y += largest_height
        end
      end
    end

    less_file = File.new(Rails.root.join('app', 'assets', 'stylesheets', 'application', 'set_symbols.less'), 'w')

    less_file.puts ERB.new(File.read(template_file), 0, '>').result(binding)

    less_file.close
  end

  desc 'Make card set divider image sheets.'
  task :make_card_set_dividers => :environment do
    card_width_inches = 3.48

    card_height_inches = 2.49

    resolution = 300.0

    card_width_pixels = (card_width_inches * resolution).to_i

    card_height_pixels = (card_height_inches * resolution).to_i

    symbol_width = (card_width_pixels * 0.50).to_i

    symbol_height = (card_height_pixels * 0.50).to_i

    border_width_inches = 0.05

    border_width_pixels = (border_width_inches * resolution).to_i

    text_offset_x_inches = 0.20

    text_offset_x_pixels = (text_offset_x_inches * resolution).to_i

    text_offset_y_inches = 0.20

    text_offset_y_pixels = (text_offset_y_inches * resolution).to_i

    card_sets = CardSet.order('`card_sets`.`release_date` ASC')

    temporary_directory = Rails.root.join('tmp', 'card_set_dividers')

    FileUtils.mkdir_p(temporary_directory)

    card_sets.each do |card_set|
      set_code = card_set.code.downcase

      file = Rails.root.join('app', 'assets', 'images', 'sets', "#{set_code}-c.svg").to_s

      new_file = File.join(temporary_directory, "#{set_code}.png").to_s

      divider_file = File.join(temporary_directory, "#{set_code}-divider.png").to_s

      if File.exist?(new_file)
        width, height = %x(identify #{Shellwords.escape(new_file)}).split(' ')[2].split('x').map { |d| d.to_i }

        if width > symbol_width || height > symbol_height || (width < symbol_width && height != symbol_height) || (height < symbol_height && width != symbol_width)
          convert = true
        else
          convert = false
        end
      else
        convert = true
      end

      if convert
        system("inkscape --export-png=#{Shellwords.escape(new_file)} --export-background-opacity=0 --export-width=#{symbol_width} --without-gui #{Shellwords.escape(file)} > /dev/null 2>&1")

        system("convert #{Shellwords.escape(new_file)} -resize #{symbol_width}x#{symbol_height}\\> #{Shellwords.escape(new_file)}")
      end

      if File.exist?(divider_file)
        FileUtils.rm_rf(divider_file)
      end

      system("convert #{Shellwords.escape(new_file)} -gravity center -extent #{card_width_pixels}x#{card_height_pixels} -background none #{Shellwords.escape(divider_file)}")

      system("convert #{Shellwords.escape(divider_file)} -stroke black -strokewidth #{border_width_pixels} -fill none -draw \"rectangle 0,0 #{card_width_pixels - 1},#{card_height_pixels - 1}\" #{Shellwords.escape(divider_file)}")

      name_x = text_offset_x_pixels

      name_y = (text_offset_y_pixels * 1.5).to_i

      release_date_x = text_offset_x_pixels

      if card_set.name.length > 32
        release_date_y = name_y + 50

        name_font_size = 45
      else
        release_date_y = name_y + 60

        name_font_size = 60
      end

      release_date_font_size = 40

      system("convert #{Shellwords.escape(divider_file)} -font /System/Library/Fonts/Avenir.ttc -fill black -pointsize #{name_font_size} -annotate +#{name_x}+#{name_y} \"#{Shellwords.escape(card_set.name)}\" #{Shellwords.escape(divider_file)}")

      system("convert #{Shellwords.escape(divider_file)} -font /System/Library/Fonts/Avenir.ttc -fill black -pointsize #{release_date_font_size} -annotate +#{release_date_x}+#{release_date_y} \"#{Shellwords.escape(card_set.release_date.strftime('%B %e, %Y'))}\" #{Shellwords.escape(divider_file)}")
    end
  end

  desc 'Make printable sheets from card set dividers.'
  task :make_card_set_divider_sheets => :environment do
    divider_files = Dir.glob(Rails.root.join('tmp', 'card_set_dividers', '*-divider.png'))

    card_width_inches = 3.48

    card_height_inches = 2.49

    resolution = 300.0

    card_width_pixels = (card_width_inches * resolution).to_i

    card_height_pixels = (card_height_inches * resolution).to_i

    sheet_width = (card_width_pixels * 3).to_i

    sheet_height = (card_height_pixels * 3).to_i

    guide_line_width = (resolution * 0.015625).to_i

    margin = 50

    divider_files.each_slice(9).with_index do |files, index|
      divider_sheet_file = Rails.root.join('tmp', 'card_set_dividers', "dividers-#{'%02i' % index}.png").to_s

      system("montage #{files.map { |file| Shellwords.escape(file) }.join(' ')} -background none -mode Concatenate -tile 3x #{Shellwords.escape(divider_sheet_file)} > /dev/null 2>&1")

      system("convert #{Shellwords.escape(divider_sheet_file)} -gravity center -background none -extent #{sheet_width + (margin * 2)}x#{sheet_height + (margin * 2)} #{Shellwords.escape(divider_sheet_file)}")

      system("convert #{Shellwords.escape(divider_sheet_file)} -stroke black -strokewidth #{guide_line_width} -draw \"line #{card_width_pixels + margin},0 #{card_width_pixels + margin},#{sheet_height + (margin * 2)}\" #{Shellwords.escape(divider_sheet_file)}")

      system("convert #{Shellwords.escape(divider_sheet_file)} -stroke black -strokewidth #{guide_line_width} -draw \"line #{(card_width_pixels * 2) + margin},0 #{(card_width_pixels * 2) + margin},#{sheet_height + (margin * 2)}\" #{Shellwords.escape(divider_sheet_file)}")

      system("convert #{Shellwords.escape(divider_sheet_file)} -stroke black -strokewidth #{guide_line_width} -draw \"line 0,#{card_height_pixels + margin} #{sheet_width + (margin * 2)},#{card_height_pixels + margin}\" #{Shellwords.escape(divider_sheet_file)}")

      system("convert #{Shellwords.escape(divider_sheet_file)} -stroke black -strokewidth #{guide_line_width} -draw \"line 0,#{(card_height_pixels * 2) + margin} #{sheet_width + (margin * 2)},#{(card_height_pixels * 2) + margin}\" #{Shellwords.escape(divider_sheet_file)}")

      system("convert -units PixelsPerInch #{Shellwords.escape(divider_sheet_file)} -density #{resolution.to_i} #{Shellwords.escape(divider_sheet_file)}")
    end
  end
end
