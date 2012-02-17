class CreateRounds < ActiveRecord::Migration
  def change
    create_table   :rounds do |t|
      t.references :company
      t.string     :accession, :null => false
      t.string     :filing_url, :null => false, :unique => true
      t.string     :use_of_funds, :default => 'Unknown'
      t.string     :revenue_range, :default => 'Unknown'
      t.string     :kind
      t.date       :first_investment
      t.date       :end_date
      t.integer    :raised, :default => 0
      t.integer    :tried_to_raise, :default => 0
      t.integer    :investor_count, :default => 0
      t.integer    :minimum_invested
      t.boolean    :merger
      t.boolean    :acquired
      t.timestamps
    end
    add_index :rounds, :company_id
  end
end
