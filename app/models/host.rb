class Host < ActiveRecord::Base
  belongs_to :institution
  has_many :layers
  has_many :pings

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

  def last_ping_status
    pings.recent_status
  end

  def layers_count(options = {})
    if options[:force_update]
      Rails.cache.write("host/#{id}/overall_status", calculate_layers_count)
    end
    Rails.cache.fetch("host/#{id}/layers_count", expires_in: 24.hours) do
      calculate_layers_count
    end
  end

  private

  def calculate_overall_status
    Status.where(layer_id: layers)
          .where(latest: true)
          .select(:status)
          .group(:status)
          .count
  end

  def calculate_layers_count
    layers.count
  end
end
