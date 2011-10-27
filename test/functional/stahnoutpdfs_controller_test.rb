require 'test_helper'

class StahnoutpdfsControllerTest < ActionController::TestCase
  test "should get pdfdown" do
    get :pdfdown
    assert_response :success
  end

end
