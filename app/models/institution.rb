class Institution < ActiveRecord::Base
  has_many :hosts

  def layer_count
    hosts = Host.where(institution_id: id).ids
    endpoints = Endpoint.where(host: hosts)
    Layer.where(endpoint: endpoints).count
  end
end
