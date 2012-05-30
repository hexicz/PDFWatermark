# coding: utf-8
# Vlozitpdf model slouží k evidenci PDF dokumentů
#
# => id - int
# => vlozil - string
# => tisk - boolean
# => kopirovat - boolean
# => created_at - datetime
# => updated_at - datetime
# => soubor_file_name - string
# => soubor_content_type - string
# => soubor_file_size - integer
# => soubor_updated_at - datetime
# => updated_at - datetime
# => paticka - string
# => hashString - string
# => distribuce - string
# => poznamka - text
# => name - string
# => price - decimal(5,2)
class Vlozitpdf < ActiveRecord::Base
	has_attached_file :soubor, :path=> ":rails_root/public/pdf/:basename.:extension"
	
	has_many :comments

	before_create :edit_file_name
	
	validates :vlozil, :presence => true
	validates_attachment_presence :soubor
	validates_attachment_content_type :soubor, :content_type => ["application/pdf"], :message => "není PDF!"

	# generate PayPal URL
	def paypal_url(current_user)

		invoice = "I" + Time.now.to_i.to_s
		user = User.find_by_username(current_user)
		if !user
      		user = User.new(:username => current_user, :uploaded => 0)
      		user.save!
    	end
		purchase = Purchase.new(:user_id => user.id, :pdf_id => id, :invoice => invoice)
		purchase.save!

	  values = {
	    :business => "hovorj_1336642396_biz@fel.cvut.cz",
	    :cmd => "_xclick",
	    :upload => 1,
	    :return => "https://simple.felk.cvut.cz/vlozitpdfs/",
	    :invoice => invoice,
	    :currency_code => "GBP",
	    :notify_url => "https://simple.felk.cvut.cz/notify/"
	  }

	  values.merge!({
	    "amount" => price,
	    "item_name" => "PDF dokument: " + name,
	    "item_number" => id,
	    "quantity" => 1
	  })
	  
	  "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
  end

	private

	# Rename file
	def edit_file_name
		extension = File.extname(soubor_file_name).downcase
		fname = File.basename(soubor_file_name,extension)
		fname.gsub(/[^0-9A-Za-z]/, '')
		self.soubor.instance_write(:file_name, "#{fname}#{extension}")
	end

end
