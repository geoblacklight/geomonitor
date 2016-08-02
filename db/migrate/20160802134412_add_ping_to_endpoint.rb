class AddPingToEndpoint < ActiveRecord::Migration
  def change
    add_reference :pings, :endpoint, index: true
    remove_reference(:pings, :host, index: true)
    add_column(:endpoints, :pings_count, :integer)
    remove_column(:hosts, :pings_count)
  end
end
