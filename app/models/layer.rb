class Layer < ActiveRecord::Base
  belongs_to :host
  has_many :statuses

  def current_status
    Status.where(layer_id: self.id).last
  end
end
