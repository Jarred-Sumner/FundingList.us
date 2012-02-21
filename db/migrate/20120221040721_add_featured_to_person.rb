class AddFeaturedToPerson < ActiveRecord::Migration
  def change
    add_column :people, :featured, :boolean

  end
end
