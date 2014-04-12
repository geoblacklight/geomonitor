class Host < ActiveRecord::Base
  belongs_to :institution
  has_many :layers
end
