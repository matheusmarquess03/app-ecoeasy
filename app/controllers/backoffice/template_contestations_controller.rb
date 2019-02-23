# frozen_string_literal: true

module Backoffice
  class TemplateContestationsController < BackofficeController
    before_action :set_template, only: %i[edit update destroy]

    def index
      @templates = TemplateContestation.all
    end

    def new
      @template = TemplateContestation.new
    end

    def create
      @template = TemplateContestation.new(template_params)
      @template.save!

      flash[:success] = 'Contrato cadastrado com sucesso'
      redirect_to backoffice_template_contestations_path
    rescue StandardError
      flash[:alert] = 'Falha ao cadastrar o formulário de contestação.'
      render :new
    end

    def destroy
      if @template.destroy
        flash[:success] = 'Contrato deletado com sucesso'
      else
        flash[:alert] = 'Falha ao deletar o formulário de contestação.'
      end

      redirect_to backoffice_template_contestations_path
    end

    def destroy_attachment
      @blob_file = ActiveStorage::Blob.find_signed(params[:id])
      @blob_file.attachments.first.purge
        @blob_file.purge
      redirect_back fallback_location: backoffice_template_contestations_path
    end

    private

    def template_params
      params.fetch(:template_contestation, {}).permit(:file)
    end

    def set_template
      @template = TemplateContestation.find(params[:id])
    end
  end
end
