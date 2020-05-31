class Job < ApplicationRecord
  include AASM

  aasm do
    state :ready, initial: true
    state :finished

    event :do_job do
      transitions from: :ready, to: :finished,
        success: -> { tell_the_world }
    end
  end

  def tell_the_world
    puts "Transition was a success!"
  end
end
