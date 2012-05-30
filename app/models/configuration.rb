# Model Configuration slouží k ukládání a načítání konfiguračních promměných z databáze
#
# => id - int
# => key - string
# => value - string
# => created_at - datetime
# => updated_at - datetime
class Configuration < ActiveRecord::Base
end
