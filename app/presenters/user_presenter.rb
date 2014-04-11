class UserPresenter < BasePresenter
  def initialize(user, template)
    super

    @user = user
  end

  def role
    @user.role.titleize
  end

  def current_sign_in_at
    if @user.current_sign_in_at.present?
      @user.current_sign_in_at.to_s(:normal)
    else
      @template.t('na')
    end
  end

  def last_sign_in_at
    if @user.last_sign_in_at.present?
      @user.last_sign_in_at.to_s(:normal)
    else
      @template.t('na')
    end
  end

  def current_sign_in_ip
    if @user.current_sign_in_ip.present?
      @user.current_sign_in_ip
    else
      @template.t('na')
    end
  end

  def last_sign_in_ip
    if @user.last_sign_in_ip.present?
      @user.last_sign_in_ip
    else
      @template.t('na')
    end
  end

  def receive_newsletters
    if @user.receive_newsletters
      @template.t('yes')
    else
      @template.t('no')
    end
  end

  def receive_sign_up_alerts
    if @user.receive_sign_up_alerts
      @template.t('yes')
    else
      @template.t('no')
    end
  end

  def receive_contact_alerts
    if @user.receive_contact_alerts
      @template.t('yes')
    else
      @template.t('no')
    end
  end

  def email_link
    @template.link_to '<span class="glyphicon glyphicon-envelope"></span>'.html_safe, "mailto:#{@user.email}", :rel => 'tooltip', :title => 'Send Email'
  end
end
