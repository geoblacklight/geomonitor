class Host < ActiveRecord::Base
  belongs_to :institution
  has_many :layers
  has_many :pings

  delegate :name,
           to: :institution,
           prefix: true

  def status
    Layer.where(host_id: id).ids
    Status.where(layer_id: layers)
                   .where(latest: true)
                   .select(:status)
                   .group(:status)
                   .count
  end

  def last_ping_status
    pings.recent_status
  end
end
