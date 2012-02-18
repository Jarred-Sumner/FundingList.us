class ChangeOtherInSecuritiesToText < ActiveRecord::Migration
  def change
    change_column :securities, :other, :text
  end
end
