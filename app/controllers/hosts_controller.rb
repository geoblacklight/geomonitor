class HostsController < ApplicationController
  def index
    @hosts = Host.all.includes(:institution)
  end

  def show
    @layers = Layer.current_recent_status(params).page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @layers.to_json(include: :latest_status) }
    end
  end
end
