class HostsController < ApplicationController
  def index
    @hosts = Host.all.includes(:institution)
  end

  def show
    @layers = Layer.where(host_id: params[:id]).includes(:latest_status)
  end
end
