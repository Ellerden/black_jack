require_relative 'card'

class Deck
  attr_accessor :all
  NUM = %w[A K Q J] + (2..10).to_a
  SUITS = ['♣', '♦', '♥', '♠'].freeze

  def initialize
    @all = NUM.map { |n| SUITS.map { |suit| Card.new(n.to_s, suit) } }.flatten
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
