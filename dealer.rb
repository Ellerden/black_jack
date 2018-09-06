require_relative 'player'

class Dealer < Player

  def decide
    puts "ну и #{@sum}"
    if @sum <= 17
      :hit
    else
      :hold
    end
  end

end
