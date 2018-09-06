require_relative 'deck'
require_relative 'counter'

class Player
  include Counter
  attr_accessor :name, :hand, :money
  BET = 10

  def initialize(name)
    @name = name
    @hand = []
    @money = 100
  end

  def lost?
    true if @sum > 21
  end

  def hit(card)
    @hand << card if @hand.size < 3
    count(@hand)
  end

  def enough_money?
    return false if (@money - BET) < 0
    true
  end

  def empty_hand
    @hand = []
    @sum = 0
  end

  def show_hand
    result = []
     @hand.each { |card| result << "#{card.name}#{card.suit}"}
     result.join(', ').to_s
  end

  def last_card
    @hand.last.name + @hand.last.suit
  end

  def bet
    raise 'Недостаточно денег для ставки.' unless enough_money?
    @money -= BET
  end
end