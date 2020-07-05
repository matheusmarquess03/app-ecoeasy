# frozen_string_literal: true

module Backoffice::Collects
  class DailyGarbageHistoryController < BackofficeController
  before_action :set_truckers, only: %i[reports]
  before_action :set_collect, only: %i[change_status_form change_status]

	def change_status_form
		puts params.inspect 
		
		@user_id = params[:q][:schedule_user_id_eq]
		@date_start = params[:q][:collect_date_gteq]
		@date_end = params[:q][:collect_date_lteq]
	  
		respond_to do |format|
			format.js
		end
    end
	
	def change_status
	  puts "********************** INÍCIO Atualização"
	  puts params.inspect
	  
	  @user_id = params[:q][:schedule_user_id_eq]
	  @date_start = params[:q][:collect_date_gteq]
	  @date_end = params[:q][:collect_date_lteq]
	  
	  truck_id = params[:q][:truck_id]
	  landfill_id = params[:q][:landfill_id]
	  collect_weight = params[:q][:collect_weight]
	  
	  puts "Truck ID #{truck_id}" 
	  puts "Landfill ID #{landfill_id}"
	  puts "Weight #{collect_weight}"
	  
	  @collect.transaction do
		@collect.schedule.truck_id = truck_id
		@collect.schedule.save!
		
		@collect.landfill_id = landfill_id
		@collect.weight = collect_weight
		@collect.schedule.truck_id = truck_id
		@collect.status = 5
		
		@collect.save!
	  end
	  puts "********************** FIM Atualização"
	  
      flash[:notice] = 'Alteração realizada com sucesso'
	  
	  puts "user_id#{@user_id}/date_start#{@date_start}/date_end#{@date_end}"
	  
	  redirect_to backoffice_daily_garbage_history_reports_path(q: {schedule_user_id_eq:@user_id, collect_date_gteq:@date_start, collect_date_lteq:@date_end})
      
    rescue StandardError => ex
		puts "**********************ERRO!!!"
		puts "An error of type #{ex.class} happened, message is #{ex.message}"
		flash[:alert] = 'Falha ao realizar alteração'
		redirect_to backoffice_daily_garbage_history_reports_path
    end
	
    def reports
	  puts "**************Parâmetros após filtro"
	  puts params.inspect 
	  
		if(params[:q].present?)
			if(params[:q][:schedule_user_id_eq].present?)
				@user_id = params[:q][:schedule_user_id_eq]
			else
				@user_id = ""
			end
		  
			if(params[:q][:collect_date_gteq].present?)
				@date_start = params[:q][:collect_date_gteq]
			else
				@date_start = ""
			end
		  
			if(params[:q][:collect_date_lteq].present?)
				@date_end = params[:q][:collect_date_lteq]
			else
				@date_end = ""
			end
		else 
			@user_id = ""
			@date_start = ""
			@date_end = ""
		end
		
	  
	  @q = Collect.daily_garbage_collection.ransack(params[:q])

      @collects = @q.result
                    .includes(schedule: %i[user routes], landfill: :address)
                    .order(collect_date: :desc)
                    .paginate(page: params[:page], per_page: 10)

      respond_to do |format|
        format.html
        format.csv do
		  @q = Collect.daily_garbage_collection.ransack(params[:q])

		  @collects = @q.result
                    .includes(schedule: %i[user routes], landfill: :address)
                    .order(collect_date: :desc)
					
          send_data(Collect.daily_collect_to_csv(@collects),
                    filename: "coleta-de-entulho-#{Date.today}.csv")
        end
      end
	rescue StandardError => ex
		puts "**********************ERRO!!!"
		puts "An error of type #{ex.class} happened, message is #{ex.message}"
    end
	
	private 
	
	def set_truckers
      @tracking_truckers = Trucker.all.order(name: :asc)
    end
	
	def set_collect
      @collect = Collect.find(params[:id])
	  
	  @history_trucks = Truck.all.order(plate_number: :asc)
	  @history_landfills = Landfill.all.order(name: :asc)
    end
  end
end