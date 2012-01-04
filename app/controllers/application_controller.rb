class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  private 

  def authenticated?
    request.env['felid-uid'].present?
  end

  def fel_id 
    {
      :user_id      =>  request.env['felid-uid'],
      :user_email   =>  request.env['felid-mail'],
      :user_role    =>  request.env['felid-employeeType']
    }
  end

  def current_user
    @current_user = fel_id if authenticated?   
  end

end
