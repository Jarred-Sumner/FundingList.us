class CreateSecurities < ActiveRecord::Migration
  def change
    create_table :securities do |t|
      t.references :round
      t.boolean :debt
      t.boolean :acquired
      t.boolean :equity
      t.boolean :option
      t.boolean :pooled_investment_fund
      t.boolean :tenant_in_common
      t.boolean :mineral_property
      t.string :other

      t.timestamps
    end
    add_index :securities, :round_id
  end
end
