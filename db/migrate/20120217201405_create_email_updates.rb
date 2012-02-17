class CreateEmailUpdates < ActiveRecord::Migration
  def change
    create_table :email_updates do |t|
      t.string :email
      t.references :company

      t.timestamps
    end
    add_index :email_updates, :company_id
  end
end
