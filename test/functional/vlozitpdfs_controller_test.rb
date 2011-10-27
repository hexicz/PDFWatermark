require 'test_helper'

class VlozitpdfsControllerTest < ActionController::TestCase
  setup do
    @vlozitpdf = vlozitpdfs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vlozitpdfs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vlozitpdf" do
    assert_difference('Vlozitpdf.count') do
      post :create, :vlozitpdf => @vlozitpdf.attributes
    end

    assert_redirected_to vlozitpdf_path(assigns(:vlozitpdf))
  end

  test "should show vlozitpdf" do
    get :show, :id => @vlozitpdf.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @vlozitpdf.to_param
    assert_response :success
  end

  test "should update vlozitpdf" do
    put :update, :id => @vlozitpdf.to_param, :vlozitpdf => @vlozitpdf.attributes
    assert_redirected_to vlozitpdf_path(assigns(:vlozitpdf))
  end

  test "should destroy vlozitpdf" do
    assert_difference('Vlozitpdf.count', -1) do
      delete :destroy, :id => @vlozitpdf.to_param
    end

    assert_redirected_to vlozitpdfs_path
  end
end
