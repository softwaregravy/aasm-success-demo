class Job2 < ApplicationRecord
  establish_connection(:development2)
  self.table_name = 'jobs'

  def ruin_everything_helper
    self.update_column(:aasm_state, "ruined")
  end
end
