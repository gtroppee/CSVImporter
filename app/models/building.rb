class Building < ApplicationRecord
  include Versionable
  FILTERED_FIELDS = %i(manager_name)
end