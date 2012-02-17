class RoundController < ApplicationController
  respond_to :json, :html
  def index
    @rounds = Round.limit(5)
    respond_to do |format|
      format.html
      format.json { render :json => @rounds } 
    end
  end

  def show
    @round = Round.find(params[:id])
    respond_with @round
  end

  def create
    @round = Round.create(params[:round])
    if @round
      respond_with @round
    else
      render :status => 500
    end
  end

  def update
  end

  def delete
  end
end
