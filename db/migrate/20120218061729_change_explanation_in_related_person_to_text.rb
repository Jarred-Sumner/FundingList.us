class ChangeExplanationInRelatedPersonToText < ActiveRecord::Migration
  def change
    change_column :related_people, :explanation, :text
  end
end
