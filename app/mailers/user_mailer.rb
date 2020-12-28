require 'open-uri'

class UserMailer < ApplicationMailer
  def send_temporary_password
    @user = params[:user]
    @password = params[:password]
    mail to: @user.email,
         bcc: ['alan.barile@gmail.com', 'prizma.desenvolvimento@gmail.com'],
         subject: 'Senha temporária'
  end

  def send_change_status(collect)
    @collect = collect
    mail to: build_recipient(collect),
         subject: 'Atualização de status'
  end

  private

  def build_recipient(collect)
    recipients = []
    if collect.rubble_collect?
      recipients << collect&.schedule&.user&.email
      recipients << collect.user.email
    else
      recipients << collect&.schedule&.user&.email
    end
    return recipients
  end
end
