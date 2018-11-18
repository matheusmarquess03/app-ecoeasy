class UserMailer < ApplicationMailer
  def send_temporary_password
    @user = params[:user]
    @password = params[:password]
    mail to: @user.email,
         bcc: ['a.hugofonseca@gmail.com', 'david.faculdade@gmail.com', 'gustavovgarcia.sl@gmail.com'],
         subject: 'Senha temporária'

    mail to: @voucher.recipient.email,
         cc: cc << ENV['EASYLIVE_NOREPLY_EMAIL'],
         bcc: @bcc,
         subject: "EASYLIVE - Confirmação de resgate"
  end
end
