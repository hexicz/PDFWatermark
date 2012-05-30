# Model Comment slouží k připomínkování dokumentů
#
# => id - int
# => author - string
# => content - text
# => vlozitpdf_id - int
# => created_at - datetime
# => updated_at - datetime
class Comment < ActiveRecord::Base
  belongs_to :vlozitpdf
  
end
