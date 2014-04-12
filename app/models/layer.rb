class Layer < ActiveRecord::Base
  belongs_to :host
  has_many :statuses
end
