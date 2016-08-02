class AddEndpointToLayer < ActiveRecord::Migration
  def change
    add_reference :layers, :endpoint, index: true, foreign_key: true
    remove_reference(:layers, :host, index: true)
  end
end
