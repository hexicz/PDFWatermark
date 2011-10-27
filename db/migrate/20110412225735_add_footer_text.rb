class AddFooterText < ActiveRecord::Migration
  def self.up
	    add_column :vlozitpdfs, :paticka, :string
	end

	 def self.down
			remove_column :vlozitpdfs, :paticka
	end
end
