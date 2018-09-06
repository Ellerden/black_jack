require_relative 'player'

class Dealer < Player

  def decide
    puts "Перед тем как дилер решает #{@sum}"
    if @sum <= 17
      puts "решил брать"
      :hit
    else
      puts "решил не брать"
      :hold
    end
  end
end
