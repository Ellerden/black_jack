require_relative 'deck'
require_relative 'card'
require_relative 'settings'

class Player
  include Settings
  attr_reader :name
  attr_accessor :hand, :money, :sum

  def initialize(name)
    @name = name
    @hand = []
    @money = STARTING_MONEY
    @sum = 0
  end

  def lost?
    true if @sum > BJ
  end

  def hit(card)
    @hand << card if @hand.size < MAX_CARDS
    count_hand
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

  def count_hand
    # проверка если добавить 11 не будет ли перебора - будет туз 11 или 1?
    @hand.last.value = 11 if @hand.last.name == 'A' && @sum + 11 <= BJ
    @sum += @hand.last.value
  end

  def last_card
    @hand.last.name + @hand.last.suit
  end

  def bet
    raise 'Недостаточно денег для ставки.' unless enough_money?
    @money -= BET
  end
end
