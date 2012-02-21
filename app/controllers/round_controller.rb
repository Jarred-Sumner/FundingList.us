class RoundController < ApplicationController
  respond_to :json, :html

  def show
    @round = Round.find(params[:id])
    gon.round = @round
    gon.company_name = @round.company.name
    respond_with @round
  end
end
