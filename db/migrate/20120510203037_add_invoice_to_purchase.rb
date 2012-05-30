class AddInvoiceToPurchase < ActiveRecord::Migration
  def self.up
  	add_column :purchases, :invoice, :string
  end

  def self.down
  	remove_column :purchases, :invoice
  end
end
