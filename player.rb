require_relative 'deck'
require_relative 'counter'

class Player
  include Counter
  attr_accessor :name, :hand, :money
  SINGLE_BET = 10

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
   #puts "#{card.name}#{card.suit} - #{card.value}"
  # print @hand
    count(@hand)
    print @hand.each {|card| card.name}
    puts 'Game over!' if lost?
  end

  def enough_money?
    return false if (@money - SINGLE_BET) < 0
    true
  end

  def reset_game
    @money = 100
    @hand = []
    @sum = 0
  end

  def show
    result = []
     @hand.each { |card| result << "#{card.name}#{card.suit}"}
     result.to_s
  end

  def last_card
    @hand.last.name + @hand.last.suit
  end

  def bet
    raise 'Недостаточно денег для ставки.' unless enough_money?
  end

  # Это перенести в Game - если lost - то можно только пропустить ход и посмотреть что будет у дилера
  # если won то можно только пропустить ход и посмотреть, что будет у дилера

  # если ни то, ни се , то можно пропустить ход (ход переходит к дилеру) или взять еще одну карту
#
   # puts "#{card.name}#{card.suit} - #{card.value}"
  #  puts 'Game over!' if lose? || win?

end