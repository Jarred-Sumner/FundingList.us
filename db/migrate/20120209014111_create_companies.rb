class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string  :name
      t.string  :cik, :unique => true
      t.string  :city
      t.string  :state
      t.string  :incorporation_year
      t.boolean :featured
      t.timestamps
    end
  end
end
