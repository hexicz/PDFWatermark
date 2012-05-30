# Model User reprezentuje uživatele
#
# => id - int
# => username - string
# => uploaded - integer
# => created_at - datetime
# => updated_at - datetime
class User < ActiveRecord::Base
	has_many :purchases
end
