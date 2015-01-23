class Layer < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  belongs_to :host, counter_cache: true
  validates :host_id, presence: true
  has_many :statuses
  has_one :latest_status,
    -> (object) { where("latest = ?", true) }, :class_name => 'Status'

  ##
  # Finds the current status of a given layer
  #
  def current_status
    Status.find_by(layer_id: id, latest: true).status
  end

  def recent_status
    last_seven = Status.where(layer_id: id).last(7)
    ok_count = last_seven.count { |stat| stat.status == 'OK' }
    { ok: ok_count.to_f, count: last_seven.count.to_f }
  end

  ##
  # Returns a Layer's Geomonitor status score
  def recent_status_score
    recent_status[:ok] / recent_status[:count]
  end

  ## Returns a Layer's Solr status score
  def recent_status_solr_score
    Geomonitor.document_solr_score(name)
  end

  ##
  # Update the layer's Solr status score
  def update_solr_score
    Geomonitor.update_by_id id: name, score: recent_status_score
  end

  def self.current_recent_status(params)
    where(host_id: params[:id])
         .with_current_status(params[:status])
         .includes(:latest_status)
         .order(updated_at: :desc)
  end

  ##
  # Query Layer with a particular current status, if param
  # is nil then return all Layer
  # @param [String] Status set from a response examples: 'OK', '??', 'FAIL'
  #
  def self.with_current_status(status)
    if status.nil?
      all
    else
      joins(:statuses).where(statuses: { latest: true, status: status })
    end
  end
end
