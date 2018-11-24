module Api::V1
  class SchedulesController < ApiController
    before_action :set_day_schedule, only: [:show, :update]

    def show
      unless @schedule.present?
        render json: { message: 'Não há coletas agendadas para hoje para este caminhoneiro' }
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    private

    def set_day_schedule
      @schedule = Schedule.where(user_id: current_api_v1_user.id, work_day: Date.today).first
    end
  end
end
