# frozen_string_literal: true

module Backoffice::Collects
  class DailyGarbageCollectsController < BackofficeController
    before_action :set_collect, only: %i[edit update destroy change_status change_status_form]
    before_action :set_statuses_to_options, only: [:change_status_form]
    before_action :set_free_schedules_to_options, :set_routes_to_options, only: %i[new create edit update index]

    def index
      @collects = Collect.daily_garbage_collection
                         .order(collect_date: :desc)
                         .paginate(page: params[:page], per_page: 10)

      if @collects.blank?
        flash[:info] = 'Não há coletas cadastrado até o momento.'
        redirect_to new_backoffice_collects_daily_garbage_collect_path
      end
    end

    def new
      @collect = Collect.new
    end

    def create
		puts "*************** Daily Garbage CREATE"
		puts params.inspect
		
		checkSchedule = false
		
		if(params[:q][:chkSeg].present?)
			createFastSchedule(1)
			checkSchedule = true
		end

		if(params[:q][:chkTer].present?)
			createFastSchedule(2)
			checkSchedule = true
		end		
		
		if(params[:q][:chkQua].present?)
			createFastSchedule(3)
			checkSchedule = true
		end
		
		if(params[:q][:chkQui].present?)
			createFastSchedule(4)
			checkSchedule = true
		end
		
		if(params[:q][:chkSex].present?)
			createFastSchedule(5)
			checkSchedule = true
		end
		
		if(params[:q][:chkSab].present?)
			createFastSchedule(6)
			checkSchedule = true
		end
		
		if(params[:q][:chkDom].present?)
			createFastSchedule(7)
			checkSchedule = true
		end
		
		if(checkSchedule)
			flash[:success] = 'Agendamento realizado com sucesso'
		end
		puts "*************** Daily Garbage CREATE END"
		
		redirect_to backoffice_collects_daily_garbage_collects_path
	rescue StandardError => ex
		puts "**********************ERRO!!!"
		puts "An error of type #{ex.class} happened, message is #{ex.message}"
		flash[:alert] = 'Falha ao criar agendamento'
		redirect_to backoffice_collects_daily_garbage_collects_path
	end

#    def create
#      @collect = Collect.new(collect_params)
#      schedule = Schedule.find(collect_params[:schedule_id])
#      route    = Route.find(routes_params[:route_id])
#      @collect.transaction do
#        @collect.type_collect = 'daily_garbage_collection'
#        @collect.collect_date = @collect.schedule.work_day
#        @collect.confirmed!
#        schedule.routes << route
#        schedule.update!(full_schedule: true)
#      end
#      flash[:success] = 'Agendamento realizado com sucesso'
#      redirect_to backoffice_collects_daily_garbage_collects_path
#    rescue StandardError
#      flash[:alert] = 'Falha para realizar o agendamento. Tente novamente mais tarde'
#      render :new
#    end

    def edit
      @free_schedules << Schedule.find(@collect.schedule_id)
    end

    def change_status_form
      respond_to do |format|
        format.js
      end
    end

    def change_status
      @collect.update(collect_params)
      flash[:notice] = 'Status alterado com sucesso'
      redirect_to backoffice_collects_daily_garbage_collects_path
    rescue StandardError
      flash[:alert] = 'Falha ao alterar status'
      redirect_to backoffice_collects_daily_garbage_collects_path
    end

    def update
      schedule = Schedule.find(collect_params[:schedule_id])
      route    = Route.find(routes_params[:route_id])
      @collect.transaction do
        @collect.schedule.update!(full_schedule: false)
        @collect.schedule.routes.delete(@collect.schedule.routes.first)
        @collect.update!(collect_params)
        @collect.collect_date = @collect.schedule.work_day
        @collect.save!
        schedule.reload
        schedule.routes << route
        schedule.update!(full_schedule: true)
      end
      flash[:success] = 'Agendamento realizado com sucesso'
      redirect_to backoffice_collects_daily_garbage_collects_path
    rescue StandardError
      flash[:alert] = 'Falha para atualizar o agendamento. Tente novamente mais tarde'
      render :edit
    end

    def destroy
      @collect.transaction do
        @collect.schedule.update!(full_schedule: false)
        @collect.schedule.routes.delete(@collect.schedule.routes.first)
        @collect.destroy
      end
      flash[:success] = 'Agendamento deletado com sucesso'
      redirect_to backoffice_collects_daily_garbage_collects_path
    rescue StandardError
      flash[:alert] = 'Falha para atualizar o agendamento. Tente novamente mais tarde'
      redirect_to backoffice_collects_daily_garbage_collects_path
    end

    def trucker_tracking
      @schedules_trackable = Schedule.trackable(Collect.type_collects[:daily_garbage_collection])
	  #@schedules_trackable = Schedule.trackable_history(Collect.type_collects[:daily_garbage_collection])
	  
	  count = 1
	  @schedules_trackable.each do |ss|
		if (count == 1) 
			@all_routes = "\'#{ss.work_day.strftime('%Y-%m-%d')}/#{ss.user_id}@#{ss.user.name}\'"
		else 
			@all_routes = "#{@all_routes},\'#{ss.work_day.strftime('%Y-%m-%d')}/#{ss.user_id}@#{ss.user.name}\'"
		end
		
		count = count + 1
	  end
	end
	
	def tracking_history
      @tracking_truckers = Trucker.all.order(name: :asc)
	  @schedules_trackable = Schedule.trackable_history(Collect.type_collects[:daily_garbage_collection])
    end

    def reports
      @q = Collect.daily_garbage_collection.ransack(params[:q])

      @collects = @q.result
                    .includes(schedule: %i[user routes], landfill: :address)
                    .order(collect_date: :desc)
                    .paginate(page: params[:page], per_page: 10)

      respond_to do |format|
        format.html
        format.csv do
          send_data(Collect.daily_collect_to_csv(@collects),
                    filename: "coleta-de-entulho-#{Date.today}.csv")
        end
      end
    end
	
	

    private
	
	def createFastSchedule(weekDay)
		newDateStart = Collect.verify_date(params[:q][:collect_date_gteq], weekDay, 0)
		newDateEnd = Collect.verify_date(params[:q][:collect_date_lteq], weekDay, 1)
		
		tmpDate = newDateStart 
		
		puts "#{tmpDate} - #{newDateEnd}"
		
		if(tmpDate <= newDateEnd)
			while tmpDate <= newDateEnd 
				createOneFastSchedule(tmpDate)
				tmpDate = tmpDate.next_day(7)
			end
		end
	end
	
	def createOneFastSchedule(workDay)
		user_id = params[:q][:trucker_id]
		truck_id = params[:q][:truck_id]
		route_id = params[:q][:route_id]
		
		route = Route.find(route_id)
		
		Schedule.transaction do
			@fastSchedule = Schedule.new 
			@fastSchedule.work_day = workDay
			@fastSchedule.user_id = user_id
			@fastSchedule.full_schedule = true
			@fastSchedule.truck_id = truck_id
			@fastSchedule.routes << route
			@fastSchedule.save!
			
			@fastCollect = Collect.new 
			@fastCollect.status = 2
			@fastCollect.type_collect = 1
			@fastCollect.collect_date = @fastSchedule.work_day
			@fastCollect.schedule_id = @fastSchedule.id
			@fastCollect.save!
		end
	rescue StandardError => ex
		puts "**********************ERRO!!!"
		puts "An error of type #{ex.class} happened, message is #{ex.message}"
	end

    def routes_params
      params.fetch(:collect, {}).fetch(:schedules_routes, {}).permit(:route_id)
    end

    def collect_params
      params.fetch(:collect, {}).permit(:schedule_id, :status)
    end

    def set_routes_to_options
		@routes = Route.all
		@trucks = Truck.all
		@truckers = Trucker.all
    end

    def set_free_schedules_to_options
      @free_schedules = Schedule.free_schedules_to_daily_collects
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
