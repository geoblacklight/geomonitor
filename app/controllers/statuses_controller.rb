class StatusesController < ApplicationController

  def show
    puts params
    @status = Status.find_by id: params[:id]
    render json: Geomonitor::Tools.json_as_utf(@status.to_json)
  end
end
