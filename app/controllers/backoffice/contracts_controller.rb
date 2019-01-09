# frozen_string_literal: true

module Backoffice
  class ContractsController < BackofficeController
    def index
      @contracts = Contract.all
    end
  end
end
