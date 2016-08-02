class Host < ActiveRecord::Base
  belongs_to :institution
  has_many :endpoints
  has_many :layers, through: :endpoints
  validates :institution_id, presence: true
  before_create :check_and_increment

  delegate :name,
           to: :institution,
           prefix: true

  def overall_status(options = {})
    if options[:force_update]
      Rails.cache.write("host/#{id}/overall_status", calculate_overall_status)
    end
    Rails.cache.fetch("host/#{id}/overall_status", expires_in: 24.hours) do
      calculate_overall_status
    end
  end

  def layers_count(options = {})
    if options[:force_update]
      Rails.cache.write("host/#{id}/layers_count", calculate_layers_count)
    end
    Rails.cache.fetch("host/#{id}/layers_count", expires_in: 24.hours) do
      calculate_layers_count
    end
  end

  def active_layers
    layers.where(active: true)
  end

  private

  ##
  # Checks for a host name presence and if it is there increment it by 1
  def check_and_increment
    similar_hosts = get_all_with_same_name name
    if similar_hosts.count < 1
      self.name = "#{self.name} 1"
    else
      next_num = similar_hosts.max_by{|m| m.name.scan(/\d+/)}.name.scan(/\d+/).first.nil? ? 1 : similar_hosts.max_by{|m| m.name.scan(/\d+/)}.name.scan(/\d+/).first.to_i + 1
      self.name = "#{self.name} #{next_num}"
    end
  end

  def get_all_with_same_name(name)
    Host.where("name LIKE ?", "#{name}%")
  end

  def calculate_overall_status
    Status.where(layer_id: active_layers)
          .where(latest: true)
          .select(:status)
          .group(:status)
          .count
  end

  def calculate_layers_count
    active_layers.count
  end
end
