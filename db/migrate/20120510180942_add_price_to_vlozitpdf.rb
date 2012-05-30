class AddPriceToVlozitpdf < ActiveRecord::Migration
  def self.up
  	add_column :vlozitpdfs, :price, :decimal, :precision => 5, :scale => 2
  end

  def self.down
  	remove_column :vlozitpdfs, :price
  end
end
