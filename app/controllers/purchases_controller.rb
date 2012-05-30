class PurchasesController < ApplicationController
	# allow PayPal IPN POST request
	protect_from_forgery :except => [:create]

	# PayPal IPN listener
	def create
		if params[:payment_status] == "Completed"
			purchase = Purchase.find_by_invoice(params[:invoice])
			purchase.update_attribute(:purchased_at, Time.now)
		end
		render :nothing => true
	end
end
