class Collect < ApplicationRecord
  # Callbacks
  before_validation :generate_protocol_number, on: :create
  before_update :send_email, :if => :status_changed?

  # Enumerators
  enum status: [:requested, :proposed_date, :confirmed, :cancelled, :collected, :dumped]
  enum type_collect: [:rubble_collect, :daily_garbage_collection, :road_cleaning]

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
  scope :scheduled, -> {
    where(status: [ Collect.statuses[:proposed_date], Collect.statuses[:confirmed] ])
  }

  scope :trucker_collected, ->(trucker_id) {
    joins(:schedule).
    where(schedules: { user_id: trucker_id }, status: Collect.statuses[:collected])
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
          I18n.l(collect.created_at.localtime, :format => :with_day_of_week, :locale => 'pt-BR'),
          collect.collect_date.present? ? (I18n.l collect.collect_date.localtime, :format => :with_day_of_week, :locale => 'pt-BR') : 'Não definida até o momento',
          I18n.t("enums.collects.status.#{collect.status}"),
          collect.address_formatted
        ]
      end
    end
  end

  def self.daily_collect_to_csv(collects)
    headers = ['Número de protocolo', 'Motorista', 'Coleta agendada para', 'Rota', 'Situação', 'Aterro']

    CSV.generate(headers: true, encoding: 'ISO-8859-1') do |csv|
      csv << headers

      collects.each do |collect|
        csv << [
          collect.protocol_number,
          collect.schedule.user.name,
          I18n.l(collect.schedule.work_day, :format => :with_day_of_week, :locale => 'pt-BR'),
          collect.schedule&.routes.first.title,
          I18n.t("enums.collects.status.#{collect.status}"),
          collect.landfill.present? ? collect.landfill.name : 'Não foi despejado até o momento'
        ]
      end
    end
  end

  def address_formatted
    "#{address.street}, #{address.number} - #{address.district}, #{address.city}, #{address.state} - #{address.country}"
  end

  def client
    self.user
  end

  private

  def send_email
    UserMailer.send_change_status(self).deliver
  end

  def generate_protocol_number
    self.protocol_number = "#{Collect.last.id + 1}#{DateTime.now.to_i}"
  end

  def not_daily_garbage_collection?
    type_collect != 'daily_garbage_collection'
  end
end
