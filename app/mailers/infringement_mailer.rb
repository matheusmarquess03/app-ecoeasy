require 'open-uri'

class InfringementMailer < ApplicationMailer
  def send_contestation_form
    @user = params[:infringement].client

    attachments['formulario-contestacao.xls'] = open(url_for(TemplateContestation.active.first.file.service_url)) {|f| f.read }
    mail to: @user.email,
         subject: 'Formulário para contestação de multa - Recurso'
  end

  def send_bill_infringement
    # attachments['boleto.pdf'] = open(@infringement.bill.service_url) {|f| f.read }
    @user = params[:infringement].client

    attachments['boleto.pdf'] = open(url_for(Contract.first&.attachments.first.service_url)) {|f| f.read }
    mail to: @user.email,
         subject: 'Boleto bancário'
  end
end
