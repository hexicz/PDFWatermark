Pdfapp::Application.routes.draw do

  resources :configurations

  scope "(*is_free)" do
    match "pdfdown/:hashString" => "stahnoutpdfs#stahnoutpdfko"  
  end

  resources :users do
    resources :purchases
  end  
	
	get "stahnoutpdfs/pdfdown"

  resources :vlozitpdfs do 
    resources :comments
  end
  
  match "notify" => "purchases#create", :via => :post

  match "logout" => "secure#logout", :as => :logout
  match "nepovoleno" => "stahnoutpdfs#nepovoleno"
  match "nezaplaceno" => "stahnoutpdfs#nezaplaceno"
  get "home/index"

  root :to => "home#index"

end
