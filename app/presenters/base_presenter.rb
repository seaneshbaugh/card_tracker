# frozen_string_literal: true

class BasePresenter
  include Rails.application.routes.url_helpers

  delegate :content_tag, to: :@template
  delegate :link_to, to: :@template
  delegate :params, to: :@template
  delegate :t, to: :@template

  def initialize(object, template)
    @object = object

    @template = template
  end

  def method_missing(method, *args, &block)
    @object.send(method, *args, &block)
  rescue NoMethodError
    super
  end

  def created_at
    if @object.respond_to?(:created_at) && @object.created_at.present?
      @object.created_at.strftime(time_format)
    else
      t('na')
    end
  end

  def updated_at
    if @object.respond_to?(:updated_at) && @object.updated_at.present?
      @object.updated_at.strftime(time_format)
    else
      t('na')
    end
  end

  def form_title
    t("#{@object.class.base_class.to_s.underscore.pluralize}.#{@object.persisted? ? 'edit' : 'new'}.title")
  end

  def respond_to_missing?(method, include_all = false)
    @object.respond_to?(method, include_all)
  end

  private

  def time_format
    '%Y-%m-%d %H:%M:%S'
  end

  def date_format
    '%Y-%m-%d'
  end
end
