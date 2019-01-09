# frozen_string_literal: true

module Backoffice
  class ContractsController < BackofficeController
    def index
      @contracts = Contract.all
    end

    def new
      @contract = Contract.new
    end
  end
end
