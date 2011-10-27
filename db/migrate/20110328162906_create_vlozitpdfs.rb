class CreateVlozitpdfs < ActiveRecord::Migration
  def self.up
    create_table :vlozitpdfs do |t|
      t.string :vlozil
      t.boolean :tisk
      t.boolean :kopirovat

      t.timestamps
    end
  end

  def self.down
    drop_table :vlozitpdfs
  end
end
