module ApplicationHelper
  def active_controller?(controller_name)
    'active' if params[:controller] == controller_name
  end

  def active_action?(action_name)
    'active' if params[:action] == action_name
  end

  def body_class
    return unless content_for?(:body_class)

    content_for(:body_class).strip
  end

  def caution_button_class
    'btn btn-flat waves-effect waves-light yellow darken-3'
  end

  def error_messages_for(object)
    "#{object.errors.full_messages.uniq.join('. ')}."
  end

  def flash_messages
    render partial: 'shared/flash_messages'
  end

  def info_button_class
    'btn btn-flat waves-effect waves-light blue darken-3'
  end

  def page_title
    return t('.title') unless content_for?(:page_title)

    content_for(:page_title).strip
  end

  def page_meta_description
    return t('.meta_description') unless content_for?(:page_meta_description)

    content_for(:page_meta_description).strip
  end

  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize

    presenter = klass.new(object, self)

    yield presenter if block_given?

    presenter
  end

  def success_button_class
    'btn btn-flat waves-effect waves-light green darken-3'
  end

  def warning_button_class
    'btn btn-flat waves-effect waves-light red darken-3'
  end
end
