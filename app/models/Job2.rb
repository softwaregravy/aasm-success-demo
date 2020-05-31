class Job2 < ApplicationRecord
  establish_connection(:development2)
  self.table_name = 'jobs'
end
