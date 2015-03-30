class LayersController < ApplicationController

  def index
    @layers = Layer.all().includes(:statuses)
    render 'hosts/show'
  end

  def check_status
    @layer = Layer.find_by id: params[:id]
    @status = Status.run_check(@layer)
    render json: @layer.statuses.last.to_json.force_encoding('UTF-8')
  end

  def show
    @layer = Layer.find_by_name(params[:id]) || Layer.find(params[:id])
    @statuses = Status.where(layer_id: @layer.id).order(created_at: :desc)
  end

end
