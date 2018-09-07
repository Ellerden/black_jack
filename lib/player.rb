require_relative 'deck'
require_relative 'counter'
require_relative 'settings'

class Player
  include Counter
  include Settings
  attr_accessor :name, :hand, :money

  def initialize(name)
    @name = name
    @hand = []
    @money = STARTING_MONEY
  end

  def lost?
    true if @sum > BJ
  end

  def hit(card)
    @hand << card if @hand.size < MAX_CARDS
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
    @hand.each { |card| result << "#{card.name}#{card.suit}" }
    "#{result.join(', ')}. Очки: #{@sum}"
  end

  def last_card
    @hand.last.name + @hand.last.suit
  end

  def bet
    raise 'Недостаточно денег для ставки.' unless enough_money?
    @money -= BET
  end
end
