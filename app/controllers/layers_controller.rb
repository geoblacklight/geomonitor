class LayersController < ApplicationController

  def index
    @layers = Layer.all().includes(:statuses)
    render 'hosts/show'
  end

  def check_status

    @layer = Layer.find_by id: params[:id]
    @status = Status.run_check(@layer)
    render json: @layer.statuses.last
  end

end
