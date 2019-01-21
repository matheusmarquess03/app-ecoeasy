require 'open-uri'

class UserMailer < ApplicationMailer
  def send_temporary_password
    @user = params[:user]
    @password = params[:password]
    mail to: @user.email,
         bcc: ['a.hugofonseca@gmail.com', 'david.faculdade@gmail.com', 'gustavovgarcia.sl@gmail.com'],
         subject: 'Senha temporária'
  end

  def send_bill_infringement
    # attachments['boleto.pdf'] = open(@infringement.bill.service_url) {|f| f.read }
    @user = params[:infringement].client

    attachments['boleto.pdf'] = open(url_for(Contract.first&.attachments.first.service_url)) {|f| f.read }
    mail to: @user.email,
         subject: 'Boleto bancário'
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
