class InstitutionsController < ApplicationController

  def index
    @institutions = Institution.all()
  end

  def show
    @hosts = Host.where(institution_id: params[:id])
  end

end
