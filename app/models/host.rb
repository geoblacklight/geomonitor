class Host < ActiveRecord::Base
  belongs_to :institution
  has_many :layers

  def status
    layers = Layer.where(host_id: self.id).ids
    Status.where(layer_id: layers).select(:status).group(:status).count
  end
end
