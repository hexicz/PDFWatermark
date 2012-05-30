class AddNameToVlozitpdf < ActiveRecord::Migration
  def self.up
  	add_column :vlozitpdfs, :name, :string
  end

  def self.down
  	remove_column :vlozitpdfs, :name
  end
end
