module ApplicationHelper
  def body_class
    if content_for?(:body_class)
      " class=\"#{content_for(:body_class).strip}\"".html_safe
    else
      ''
    end
  end

  def flash_messages
    render :partial => 'shared/flash_messages'
  end

  def flash_message_alert_class(name)
    case name
      when :auccess, :notice
        'alert-success'
      when :info
        'alert-info'
      when :warning
        'alert-warning'
      when :danger, :alert, :error
        'alert-danger'
      else
        'alert-info'
    end
  end

  def is_active_controller?(controller_name)
    'active' if params[:controller] == controller_name
  end

  def is_active_action?(action_name)
    'active' if params[:action] == action_name
  end

  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize

    presenter = klass.new(object, self)

    yield presenter if block_given?

    presenter
  end
end
