class ChangeFilingUrlAndUseOfFundsToText < ActiveRecord::Migration
  def change
    change_column :rounds, :filing_url,   :text
    change_column :rounds, :use_of_funds, :text
  end
end
