# frozen_string_literal: true

module Admin
  module AdminHelper
    def cancel_icon(options = {})
      content_tag(:i, 'clear', class: classnames('material-icons', options[:class]))
    end

    def cancel_icon_link(url_or_path, options = {})
      link_to(url_or_path, class: warning_button_class) do
        label = options[:label].to_s if options[:label]

        cancel_icon(class: { 'left' => label }) + label
      end
    end

    def delete_icon(options = {})
      content_tag(:i, 'delete_forever', class: classnames('material-icons', options[:class]))
    end

    def delete_icon_link(url_or_path, options = {})
      link_to(url_or_path, class: warning_button_class, rel: 'nofollow', method: :delete, data: { confirm: t('confirm_delete') }) do
        label = options[:label].to_s if options[:label]

        delete_icon(class: { 'left' => label }) + label
      end
    end

    def edit_icon(options = {})
      content_tag(:i, 'edit', class: classnames('material-icons', options[:class]))
    end

    def edit_icon_link(url_or_path, options = {})
      link_to(url_or_path, class: success_button_class) do
        label = options[:label].to_s if options[:label]

        edit_icon(class: { 'left' => label }) + label
      end
    end

    def gem_dependencies
      lockfile = Bundler::LockfileParser.new(Bundler.read_file(Rails.root.join('Gemfile.lock')))

      lockfile.specs.map do |spec|
        {
          name: spec.name,
          version: spec.version.version,
          dependencies: spec.dependencies.map { |dependency| { name: dependency.name, requirement: dependency.requirement } }
        }
      end
    end
  end
end
