class CreateRelatedPeople < ActiveRecord::Migration
  def change
    create_table   :related_people do |t|
      t.references :round
      t.references :person
      t.boolean    :executive_officer
      t.boolean    :director
      t.boolean    :promoter
      t.string     :explanation
      t.timestamps
    end
    add_index :related_people, :round_id
    add_index :related_people, :person_id
  end
end
