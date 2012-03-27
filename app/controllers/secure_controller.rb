class SecureController < ApplicationController
 
  def index
  
  end

  def logout
    @current_user = nil
    redirect_to 'https://login.feld.cvut.cz/felid/logout?return=https://simple.felk.cvut.cz'
  end

end
