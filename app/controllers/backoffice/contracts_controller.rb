# frozen_string_literal: true

module Backoffice
  class ContractsController < BackofficeController
    before_action :set_contract, only: [:edit, :update, :destroy]

    def index
      @contracts = Contract.all
    end

    def new
      @contract = Contract.new
    end

    def create
      @contract = Contract.new(contract_params)
      @contract.save!

      flash[:success] = 'Contrato cadastrado com sucesso'
      redirect_to backoffice_contracts_path
    rescue StandardError
      flash[:alert] = 'Falha ao cadastrar o contrato.'
      render :new
    end

    def edit; end

    def update
      @contract.images.attach(contract_params[:images])
      @contract.update!(contract_params)
      flash[:success] = 'Contrato atualizado com sucesso'
      redirect_to backoffice_contracts_path
    rescue StandardError
      flash[:alert] = 'Falha ao atualizar o contrato.'
      render :edit
    end

    def destroy
      if @contract.destroy
        flash[:success] = 'Contrato deletado com sucesso'
        redirect_to backoffice_contracts_path
      else
        flash[:alert] = 'Falha ao deletar o contrato.'
        redirect_to backoffice_contracts_path
      end
    end

    private

    def contract_params
      params.fetch(:contract, {}).permit(:name, :observation, images: [])
    end

    def set_contract
      @contract = Contract.find(params[:id])
    end
  end
end
