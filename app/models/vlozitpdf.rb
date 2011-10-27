# coding: utf-8

class Vlozitpdf < ActiveRecord::Base
	has_attached_file :soubor, :path=> ":rails_root/public/pdf/:basename.:extension"

	before_create :edit_file_name
	
	validates :vlozil, :presence => true
	validates_attachment_presence :soubor
	validates_attachment_content_type :soubor, :content_type => ["application/pdf"], :message => "není PDF!"

	private
		def edit_file_name
			extension = File.extname(soubor_file_name).downcase
			fname = File.basename(soubor_file_name,extension)
			fname.gsub(/[^0-9A-Za-z]/, '')
			self.soubor.instance_write(:file_name, "#{fname}#{extension}")
		end

end
