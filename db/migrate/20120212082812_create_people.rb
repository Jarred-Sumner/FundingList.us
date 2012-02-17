class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :street_address_one
      t.string :street_address_two
      t.string :city
      t.string :zip_code
  
      t.timestamps
    end
  end
end
