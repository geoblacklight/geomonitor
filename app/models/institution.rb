class Institution < ActiveRecord::Base
  has_many :hosts

  def layer_count
    hosts = Host.where(institution_id: self.id).ids
    Layer.where(host_id: hosts).count
  end
end
