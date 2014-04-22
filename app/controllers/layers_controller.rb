class LayersController < ApplicationController

  def index
    @layers = Layer.all().includes(:statuses)
    render 'hosts/show'
  end

  def check_status

    @layer = Layer.find_by id: params[:id]
    @status = Status.run_check(@layer)
    render json: Geomonitor::Tools.json_as_utf(@layer.statuses.last.to_json)
  end

  def show
    @layer = Layer.find(params[:id])
    @statuses = Status.where(layer_id: params[:id]).order(created_at: :desc)
  end

end
