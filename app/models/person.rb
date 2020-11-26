class Person < ApplicationRecord
  include Versionable
  FILTERED_FIELDS = %i(email home_phone_number mobile_phone_number address)
end