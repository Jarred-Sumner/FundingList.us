class PeopleController < ApplicationController
  def show
    @person = Person.find(params[:id])
    @related_person = RelatedPerson.find_by_person_id(@person.id)
    respond_to do |format|
      format.html
      format.json { render :json => @person }
    end
  end
end
