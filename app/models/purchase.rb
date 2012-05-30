# Model Purchase slouží k evidování nákupů PDF dokumentů uživateli
#
# => id - int
# => user_id - int
# => pdf_id - int
# => purchased_at - datetime	
# => invoice - string
# => created_at - datetime
# => updated_at - datetime
class Purchase < ActiveRecord::Base
  belongs_to :user

end
