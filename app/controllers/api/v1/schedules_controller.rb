module Api::V1
  class SchedulesController < ApiController
    before_action :set_day_schedule, only: [:show]

    def show
    end

    private

    def set_day_schedule
      @schedule = Schedule.where(user_id: current_api_v1_user.id, work_day: Date.today-1).first
    end
  end
end
