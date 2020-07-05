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
	
	collect_list = Collect.select("date_part('month',collect_date) AS mes, date_part('year', collect_date) AS ano, sum(weight) AS peso").where("collect_date IS NOT NULL").group("date_part('month',collect_date),date_part('year', collect_date)").order("date_part('year',collect_date),date_part('month',collect_date)")
	
	count = 1
	
	puts "INICIO" 
	
	result_list = ""
	
	collect_list.each do |c|
		
		mes = FirebaseDatum.convertMonth(c.mes)
		ano = "%d" % c.ano
		
		if count == 1
			result_list = "{y:\'#{mes}/#{ano}\',x:#{c.peso}}"
		else 
			result_list = "#{result_list},{y:\'#{mes}/#{ano}\',x:#{c.peso}}"
		end
        
		count = count + 1
		
	end
	
	puts "FIM" 
	
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
