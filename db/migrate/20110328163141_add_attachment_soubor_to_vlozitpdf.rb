class AddAttachmentSouborToVlozitpdf < ActiveRecord::Migration
  def self.up
    add_column :vlozitpdfs, :soubor_file_name, :string
    add_column :vlozitpdfs, :soubor_content_type, :string
    add_column :vlozitpdfs, :soubor_file_size, :integer
    add_column :vlozitpdfs, :soubor_updated_at, :datetime
  end

  def self.down
    remove_column :vlozitpdfs, :soubor_file_name
    remove_column :vlozitpdfs, :soubor_content_type
    remove_column :vlozitpdfs, :soubor_file_size
    remove_column :vlozitpdfs, :soubor_updated_at
  end
end
