require_relative 'player'

class Dealer < Player
  def decide
    @sum < 17 ? :hit : :hold
  end
end
