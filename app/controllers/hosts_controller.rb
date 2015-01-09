class HostsController < ApplicationController
  def index
    @hosts = Host.all.includes(:institution)
  end

  def show
    @layers = Layer.with_current_status(params[:status])
                   .where(host_id: params[:id])
                   .includes(:latest_status)
                   .order(updated_at: :desc)
                   .page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @layers.to_json(include: :latest_status) }
    end
  end
end
