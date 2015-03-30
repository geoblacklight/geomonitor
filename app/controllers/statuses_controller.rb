class StatusesController < ApplicationController

  def show
    puts params
    @status = Status.find_by id: params[:id]
    render json: @status.to_json.force_encoding('UTF-8')
  end
end
