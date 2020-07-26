class Backoffice::DashboardController < BackofficeController
	before_action :set_truckers, only: %i[trucker_analysis]
	before_action :set_trucks, only: %i[truck_analysis]
	before_action :set_routes, only: %i[route_analysis]
	
	def index
		@mulcts = Evidence.mulct
		@incidents = Evidence.incident
		@rubble_collects = Collect.rubble_collect.collected
		@daily_collect = Collect.daily_garbage_collection.collected
	
		@monthly_collect_weight = Collect.monthly_collect
		@monthly_collect_distance = FirebaseDatum.monthly_collect
	end
  
	def trucker_analysis

	end
	
	def truck_analysis

	end
	
	def route_analysis

	end
	
	def set_routes
		@routes = Route.all.order(title: :asc)
	  
		puts "*********** INICIO set_routes"
		puts params.inspect 
	  
		if(params[:q].present?)
			route_id = params[:q][:route_id]
			date_start = params[:q][:date_start]
			date_end = params[:q][:date_end]
			
			@monthly_collect_weight = Collect.route_monthly_collect(date_start, date_end, route_id)
			@monthly_collect_distance = FirebaseDatum.route_monthly_collect(date_start, date_end, route_id)
		end 
	rescue StandardError => ex
		puts "**********************ERRO!!!"
		puts "An error of type #{ex.class} happened, message is #{ex.message}"
		flash[:alert] = 'Falha ao realizar alteração'
		redirect_to backoffice_dashboard_route_analysis_path
    end
	
	def set_trucks
		@trucks = Truck.all.order(plate_number: :asc)
	  
		puts "*********** INICIO set_trucks"
		puts params.inspect 
	  
		if(params[:q].present?)
			truck_id = params[:q][:truck_id]
			date_start = params[:q][:date_start]
			date_end = params[:q][:date_end]
			
			@monthly_collect_weight = Collect.truck_monthly_collect(date_start, date_end, truck_id)
			@monthly_collect_distance = FirebaseDatum.truck_monthly_collect(date_start, date_end, truck_id)
		end 
	rescue StandardError => ex
		puts "**********************ERRO!!!"
		puts "An error of type #{ex.class} happened, message is #{ex.message}"
		flash[:alert] = 'Falha ao realizar alteração'
		redirect_to backoffice_dashboard_truck_analysis_path
    end
	
	def set_truckers
		@truckers = Trucker.all.order(name: :asc)
	  
		puts "*********** INICIO set_truckers"
		puts params.inspect 
	  
		if(params[:q].present?)
			user_id = params[:q][:user_id]
			date_start = params[:q][:date_start]
			date_end = params[:q][:date_end]
			
			@monthly_collect_weight = Collect.user_monthly_collect(date_start, date_end, user_id)
			@monthly_collect_distance = FirebaseDatum.user_monthly_collect(date_start, date_end, user_id)
		end 
	rescue StandardError => ex
		puts "**********************ERRO!!!"
		puts "An error of type #{ex.class} happened, message is #{ex.message}"
		flash[:alert] = 'Falha ao realizar alteração'
		redirect_to backoffice_dashboard_trucker_analysis_path
    end
end

