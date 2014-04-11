class BasePresenter
  def initialize(object, template)
    @object = object

    @template = template
  end

  def method_missing(method, *args, &block)
    begin
      @object.send(method, *args, &block)
    rescue NoMethodError
      super
    end
  end

  def created_at
    if @object.created_at.present?
      @object.created_at.to_s(:normal)
    else
      @template.t('na')
    end
  end

  def updated_at
    if @object.updated_at.present?
      @object.updated_at.to_s(:normal)
    else
      @template.t('na')
    end
  end

  def form_title
    @template.t("#{@object.class.base_class.to_s.underscore.pluralize}.#{@object.persisted? ? 'edit' : 'new'}.title")
  end
end
