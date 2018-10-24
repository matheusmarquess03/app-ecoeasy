module Api::V1
  class SchedulesController < ApiController
    before_action :set_day_schedule, only: [:show]

    def show
      unless @schedule.present?
        render json: { message: 'Não há coletas agendadas para hoje para este caminhoneiro' }
      end
    rescue StandardError => e
      render_error(500, e.message)
    end

    private

    def set_day_schedule
      @schedule = Schedule.where(user_id: current_api_v1_user.id, work_day: Date.today).first
    end
  end
end
