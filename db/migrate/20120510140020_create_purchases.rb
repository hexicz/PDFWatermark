class CreatePurchases < ActiveRecord::Migration
  def self.up
    create_table :purchases do |t|
      t.datetime :purchased_at
      t.integer :pdf_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :purchases
  end
end
