# frozen_string_literal: true

module Admin
  module AdminHelper
    def icon_edit_link(url_or_path)
      render partial: 'shared/icon_edit_link', locals: { url_or_path: build_url_or_path_for(url_or_path) }
    end

    def icon_delete_link(url_or_path)
      render partial: 'shared/icon_delete_link', locals: { url_or_path: build_url_or_path_for(url_or_path) }
    end

    def build_url_or_path_for(url_or_path = '')
      url_or_path = eval(url_or_path) if url_or_path =~ /_path|_url|@/

      url_or_path
    end

    def edit_and_delete_header_columns(klass)
      result = ''

      result += '<th>&nbsp;</th>' if can? :update, klass

      result += '<th>&nbsp;</th>' if can? :destroy, klass

      result.html_safe
    end

    def edit_and_delete_columns(object)
      object_base_class_name = object.class.base_class.to_s.underscore

      result = ''

      if can? :update, object
        result += "<td>#{link_to '<span class="glyphicon glyphicon-edit"></span>'.html_safe, send("edit_admin_#{object_base_class_name}_path", object), class: 'btn btn-mini', rel: 'tooltip', title: t('edit')}</td>"
      elsif can? :update, object.class
        result += '<td>&nbsp;</td>'
      end

      if can? :destroy, object
        result += "<td>#{link_to '<span class="glyphicon glyphicon-remove"></span>'.html_safe, send("admin_#{object_base_class_name}_path", object), method: :delete, data: { confirm: t('confirm_delete') }, class: 'btn btn-mini', rel: 'tooltip', title: t('delete')}</td>"
      elsif can? :destroy, object.class
        result += '<td>&nbsp;</td>'
      end

      result.html_safe
    end

    def gem_dependencies
      lockfile = Bundler::LockfileParser.new(Bundler.read_file(Rails.root.join('Gemfile.lock')))

      lockfile.specs.map { |spec| { name: spec.name, version: spec.version.version, dependencies: spec.dependencies.map { |dependency| { name: dependency.name, requirement: dependency.requirement } } } }
    end
  end
end
