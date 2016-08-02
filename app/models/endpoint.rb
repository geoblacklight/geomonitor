class Endpoint < ActiveRecord::Base
  has_many :pings
  belongs_to :host
  validates :url, presence: true
  has_many :layers

  def last_ping_status
    pings.recent_status
  end
end
