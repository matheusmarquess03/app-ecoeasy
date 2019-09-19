module Backoffice::Collects
  class RubbleCollectsController < BackofficeController
    before_action :set_collect, only: [:edit, :change_status, :update]
    before_action :set_statuses_to_options, only: [:change_status]
    before_action :set_free_schedules_to_options, only: [:edit, :index]

    def index
      @collects = Collect.rubble_collect
    end

    def edit
      respond_to do |format|
        format.js
      end
    end

    def change_status
      respond_to do |format|
        format.js
      end
    end

    def update
      @collect.transaction do
        @collect.update(collect_params)
        flash[:notice] = 'Agenda selecionada com sucesso'
        redirect_to backoffice_collects_rubble_collects_path
      end
    rescue StandardError
      flash[:alert] = 'Falha para selecionar a agenda'
      redirect_to backoffice_collects_rubble_collects_path
    end

    def trucker_tracking
      @schedules_trackable = Schedule.trackable(Collect.type_collects[:rubble_collect])
    end

    def reports
      @q = Collect.rubble_collect.ransack(params[:q])
      @collects = @q.result.includes(:user, :address)

      respond_to do |format|
        format.html
        format.csv { send_data Collect.to_csv(@collects), filename: "coleta-de-entulho-#{Date.today}.csv" }
      end
    end

    private

    def collect_params
      params.fetch(:collect, {}).permit(:collect_date, :schedule_id, :status)
    end

    def set_free_schedules_to_options
      @free_schedules = Schedule.free_schedules
    end

    def set_collect
      @collect = Collect.find(params[:id])
    end

    def set_statuses_to_options
      @statuses = Collect.statuses.map do |status, _value|
        [
          I18n.t('enums.collects.status')[status.to_sym],
          status
        ]
      end
    end
  end
end
