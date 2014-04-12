class HostsController < ApplicationController
  def index
    @hosts = Host.all
  end

  def show
    @layers = Layer.where(host_id: params[:id]).includes(:statuses)
  end
end
