class Host < ActiveRecord::Base
  belongs_to :institution
  has_many :layers
  has_many :pings

  def status
    layers = Layer.where(host_id: self.id).ids
    status = Status.where(layer_id: layers)
                   .where(latest: true)
                   .select(:status)
                   .group(:status)
                   .count

    status
  end
end
