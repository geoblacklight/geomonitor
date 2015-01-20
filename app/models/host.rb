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

  private

  def calculate_overall_status
    Status.where(layer_id: layers)
          .where(latest: true)
          .select(:status)
          .group(:status)
          .count
  end
end
