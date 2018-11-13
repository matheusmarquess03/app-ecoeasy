class UserMailer < ApplicationMailer
  def send_temporary_password
    @user = params[:user]
    @password = params[:password]
    mail(to: @user.email, subject: 'Senha temporária')
  end
end
