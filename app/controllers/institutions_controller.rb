class InstitutionsController < ApplicationController

  def index
    @institutions = Institution.all()
  end

end
