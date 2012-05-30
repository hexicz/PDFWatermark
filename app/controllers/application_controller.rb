class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user
  helper_method :is_admin

  private 

  # check if server variable felid-uid is present and return true | false
  def authenticated?
    request.env['felid-uid'].present?
  end

  # define associative array fel_id
  def fel_id 
    {
      :user_id      =>  request.env['felid-uid'],
      :user_email   =>  request.env['felid-mail'],
      :user_role    =>  request.env['felid-employeeType']
    }
  end

  # set current user from fel_id if user is authenticated
  def current_user
    @current_user = fel_id if authenticated?   
  end

  # check if current user is ADMIN from configuration variables and return true | false
  def is_admin
    admin = Configuration.find_by_key("admin")
    if admin
      return fel_id[:user_id] == admin.value
    else
      return false
    end
  end
end
