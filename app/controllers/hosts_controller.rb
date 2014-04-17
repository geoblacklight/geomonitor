class HostsController < ApplicationController
  def index
    @hosts = Host.all.includes(:institution)
  end

  def show
    @layers = Layer.where(host_id: params[:id])
                   .includes(:latest_status)
                   .order(updated_at: :desc)
                   .page(params[:page])
  end
end
