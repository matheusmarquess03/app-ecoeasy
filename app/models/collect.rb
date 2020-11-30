# frozen_string_literal: true

# Model about all types of collect
class Collect < ApplicationRecord
  # Callbacks
  before_validation :generate_protocol_number, on: :create
  before_update :send_email, if: :status_changed?

  # Enumerators
  enum status: %i[requested proposed_date confirmed cancelled collected dumped]
  enum type_collect: %i[rubble_collect daily_garbage_collection road_cleaning]

  # Associations
  belongs_to :user, optional: true
  belongs_to :schedule, optional: true
  belongs_to :address, optional: true
  belongs_to :landfill, optional: true

  # Validates
  validates :address_id, presence: true, if: :not_daily_garbage_collection?
  validates :user_id,    presence: true, if: :not_daily_garbage_collection?
  validates :protocol_number, uniqueness: true

  # Scopes
  scope :scheduled, lambda {
    where(status: [Collect.statuses[:proposed_date],
                   Collect.statuses[:confirmed]])
  }

  scope :rubble_collect_to_dump_by_trucker, lambda { |trucker_id|
    joins(:schedule)
      .where(schedules: { user_id: trucker_id },
             status: :collected,
             type_collect: :rubble_collect)
  }

  scope :daily_collect_to_dump_by_trucker, lambda { |trucker_id|
    joins(:schedule)
      .where(schedules: { user_id: trucker_id },
             status: :confirmed,
             type_collect: :daily_garbage_collection)
  }

  scope :collects_to_dump_by_trucker, lambda { |trucker_id|
    rubble_collect_to_dump_by_trucker(trucker_id).or(
      daily_collect_to_dump_by_trucker(trucker_id)
    )
  }

  # Methods
	def self.verify_date(date, weekday, startEnd)
		tmpDateToday = Date.today
		tmpDate = Date.parse(date)
		
		#if (tmpDate < tmpDateToday)
		#	tmpDate = tmpDateToday
		#end
		
		tmpWeekDay = tmpDate.cwday
		
		puts "#{date} - #{tmpWeekDay} - #{weekday} - #{startEnd}"
		
		diff = weekday - tmpWeekDay
		
		if(startEnd == 0)
			if(tmpWeekDay == 7)
				diff = diff + 7
			end 
		
			if (tmpWeekDay != weekday)
				if(weekday < tmpWeekDay)
					diff = 7 + diff
				end 
				
				tmpDate = tmpDate.next_day(diff.abs())
			end
		else 
			if(tmpWeekDay == 1)
				diff = diff - 7
			end
			
			if (tmpWeekDay != weekday)
				tmpDate = tmpDate.next_day(-diff.abs())
			end
		end
		
		return tmpDate 
	end
	
  def self.to_csv(collects)
    headers = ['Número de protocolo', 'Nome', 'Data da solicitação', 'Data do recolhimento', 'Situação', 'Endereço']

    CSV.generate(headers: true, encoding: 'ISO-8859-1') do |csv|
      csv << headers

      collects.each do |collect|
        csv << [
          collect.protocol_number,
          collect.client.name,
          I18n.l(collect.created_at.localtime, format: :with_day_of_week, locale: 'pt-BR'),
          collect.collect_date.present? ? (I18n.l collect.collect_date.localtime, format: :with_day_of_week, locale: 'pt-BR') : 'Não definida até o momento',
          I18n.t("enums.collects.status.#{collect.status}"),
          collect.address_formatted
        ]
      end
    end
  end

  def self.daily_collect_to_csv(collects)
    headers = ['Número de protocolo', 'Motorista', 'Coleta agendada para', 'Rota', 'Situação', 'Aterro', 'Peso']

    CSV.generate(headers: true, encoding: 'ISO-8859-1') do |csv|
      csv << headers

      collects.each do |collect|
        csv << [
          collect.protocol_number,
          collect.schedule.user.name,
          I18n.l(collect.schedule.work_day, format: :with_day_of_week, locale: 'pt-BR'),
          collect.schedule&.routes.first.title,
          I18n.t("enums.collects.status.#{collect.status}"),
          collect.landfill.present? ? collect.landfill.name : 'Não foi despejado até o momento',
		  collect.weight
        ]
      end
    end
  end

  def address_formatted
    "#{address.street}, #{address.number} - #{address.district}, #{address.city}, #{address.state} - #{address.country}"
  end

  def client
    user
  end
  
  def self.monthly_collect
	
	collect_list = Collect.select("date_part('month',collect_date) AS data_month, date_part('year', collect_date) AS data_year, sum(COALESCE(weight,0)) AS data_tmp").where("collect_date IS NOT NULL").group("date_part('month',collect_date),date_part('year', collect_date)").order("date_part('year',collect_date),date_part('month',collect_date)")
	
	result_list = FirebaseDatum.returnData(collect_list)
		
	return result_list
  end
  
  def self.user_monthly_collect(date_start, date_end, user_id)
	
		collect_list = Collect.select("EXTRACT(year FROM collect_date) as data_year, EXTRACT(month FROM collect_date) as data_month, sum(COALESCE(weight,0)) as data_tmp").joins("INNER JOIN schedules ON schedules.id = collects.schedule_id AND schedules.user_id = #{user_id}").where("collect_date BETWEEN ? AND ?",date_start, date_end).group("data_month, data_year")
		
		result_list = FirebaseDatum.returnData(collect_list)
		
		return result_list
	end
	
	def self.truck_monthly_collect(date_start, date_end, truck_id)
	
		collect_list = Collect.select("EXTRACT(year FROM collect_date) as data_year, EXTRACT(month FROM collect_date) as data_month, sum(COALESCE(weight,0)) as data_tmp").joins("INNER JOIN schedules ON schedules.id = collects.schedule_id AND schedules.user_id = #{truck_id}").where("collect_date BETWEEN ? AND ?",date_start, date_end).group("data_month, data_year")
		
		result_list = FirebaseDatum.returnData(collect_list)
		
		return result_list
	end
	
	def self.route_monthly_collect(date_start, date_end, route_id)
	
		schedule_old_list = SchedulesRoute.where("route_id = ?", route_id).map{|r| r.schedule_id}
		
		schedule_old_list = "(#{schedule_old_list})"
		schedule_list = schedule_old_list.sub("[","")
		schedule_list = schedule_list.sub!("]","")

		collect_list = Collect.select("EXTRACT(year FROM collect_date) as data_year, EXTRACT(month FROM collect_date) as data_month, sum(COALESCE(weight,0)) as data_tmp").joins("INNER JOIN schedules ON schedules.id = collects.schedule_id AND schedules.id IN #{schedule_list}").where(:collect_date => date_start..date_end).group("data_month, data_year")

		result_list = FirebaseDatum.returnData(collect_list)
		
		return result_list
	end

  private

  def send_email
    UserMailer.send_change_status(self).deliver
  end

  def generate_protocol_number
    id = Collect.last.nil? ? 0 : Collect.last.id
    self.protocol_number = "#{id + 1}#{DateTime.now.to_i}"
  end

  def not_daily_garbage_collection?
    type_collect != 'daily_garbage_collection'
  end
  
end
