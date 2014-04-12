class StatusesController < ApplicationController

  def show
    puts params
    @status = Status.find_by id: params[:id]
    render json: @status
  end
end
