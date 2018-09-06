require_relative 'card'

class Deck #( ПО ИДЕЕ ЭТО И ЕСТЬ КАРД - только SHUFFLE я МОГУ ДЕЛАТЬ НА ВЕСЬ КЛАСС)
  attr_accessor :all
  NUM_FACES = ['A', 'K', 'Q', 'J'] + (2..10).to_a
  SUITS = ['♣', '♦', '♥', '♠'].freeze

  def initialize
    @all = NUM_FACES.map { |number| SUITS.map { |suit| Card.new(number.to_s, suit) } }.flatten
    shuffle
  end

  def shuffle
    @all.shuffle!
  end
  # даем игроку первую карту из колоды. мешать не надо - колода итак помешана
  # до этого. карта уже будет случайной и без sample
  def card
    card = @all.first
    @all -= [card]
    card
  end
end
