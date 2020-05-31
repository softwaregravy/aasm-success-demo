class Job < ApplicationRecord
  include AASM

  aasm do
    state :ready, initial: true
    state :finished

    event :do_job do
      transitions from: :ready, to: :finished,
        success: -> { tell_the_world }
    end

    event :job_gone_wrong do 
      transitions from: :ready, to: :finished,
        success: -> { ruin_everything }
    end

  end

  def tell_the_world
    puts "Transition was a success!"
    puts "I must already be in state finished!"
    puts "lets look: my state shows #{Job.find(id).aasm_state} BUT ..."
    puts "... lets use a separate connection pool to the database so that I can see what's really in there"
    puts "   and not just what is visible on my own connection where I've made changes"
    puts "   This other connection is in class Job2 which uses the connection pool development2 which connects to the same db"
    puts "... the DB currently holds state: #{Job2.find(id).aasm_state}"
  end

  def ruin_everything
    Job2.find(id).ruin_everything_helper
  end
end

