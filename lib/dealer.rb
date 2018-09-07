require_relative 'player'

class Dealer < Player
  def decide
    @sum < DEALER_TURNING_POINT ? :hit : :hold
  end
end
