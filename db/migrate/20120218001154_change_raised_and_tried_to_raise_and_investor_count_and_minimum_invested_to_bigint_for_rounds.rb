class ChangeRaisedAndTriedToRaiseAndInvestorCountAndMinimumInvestedToBigintForRounds < ActiveRecord::Migration
  def change
    change_column :rounds, :raised, :bigint
    change_column :rounds, :tried_to_raise, :bigint
    change_column :rounds, :investor_count, :bigint
    change_column :rounds, :minimum_invested, :bigint

  end
end
