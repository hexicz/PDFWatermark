class AddDistribuceToVlozitpdfs < ActiveRecord::Migration
  def self.up
    add_column :vlozitpdfs, :distribuce, :string
  end

  def self.down
    remove_column :vlozitpdfs, :distribuce
  end
end
