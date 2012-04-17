class AddPoznamkaToVlozitpdf < ActiveRecord::Migration
  def self.up
    add_column :vlozitpdfs, :poznamka, :text
  end

  def self.down
    remove_column :vlozitpdfs, :poznamka
  end
end
