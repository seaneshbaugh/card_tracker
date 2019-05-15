# frozen_string_literal: true

class UserPresenter < BasePresenter
  def initialize(user, template)
    super

    @user = user
  end

  def current_sign_in_at
    if @user.current_sign_in_at.present?
      @user.current_sign_in_at.strftime(time_format)
    else
      t('na')
    end
  end

  def last_sign_in_at
    if @user.last_sign_in_at.present?
      @user.last_sign_in_at.strftime(time_format)
    else
      t('na')
    end
  end

  def current_sign_in_ip
    @user.current_sign_in_ip.presence || t('na')
  end

  def last_sign_in_ip
    @user.last_sign_in_ip.presence || t('na')
  end

  def receive_newsletters
    display_boolean(@user.receive_newsletters)
  end

  def receive_sign_up_alerts
    display_boolean(@user.receive_sign_up_alerts)
  end

  def receive_contact_alerts
    display_boolean(@user.receive_contact_alerts)
  end

  def roles
    @user.roles.pluck(:name).map(&:titleize).join(', ')
  end

  def email_link
    link_to "mailto:#{@user.email}" do
      content_tag(:i, 'email', class: 'material-icons tooltipped', data: { 'tooltip' => t('send_email') })
    end
  end
end
