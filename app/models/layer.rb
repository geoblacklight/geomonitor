class Layer < ActiveRecord::Base
  belongs_to :host, counter_cache: true
  has_many :statuses
  has_one :latest_status,
    class_name: 'Status',
    conditions: ['latest = ?', true]

  def current_status
    statuses
    # Status.where(layer_id: id).where(latest: true).last
  end
  def status_count
    Status.where(layer_id: id).count()
  end
end
