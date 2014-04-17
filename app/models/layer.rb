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

  def recent_status
    last_seven = Status.where(layer_id: id).last(7)
    ok_count = last_seven.count { |stat| stat.status == 'OK' }
    { ok: ok_count.to_f, count: last_seven.count.to_f }
  end
  # def status_count
  #   Status.where(layer_id: id).count
  # end
end
