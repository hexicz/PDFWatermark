class AddHash < ActiveRecord::Migration
	def self.up
		add_column :vlozitpdfs, :hashString, :string
	end

	def self.down
		remove_column :vlozitpdfs, :hashString
	end
end
