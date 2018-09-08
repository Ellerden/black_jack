require_relative 'card'

class Deck
  attr_reader :all, :value
  NUM = %w[A K Q J] + (2..10).to_a
  SUITS = ['♣', '♦', '♥', '♠'].freeze

  def initialize
    @all = []
    cards_with_values = {}
    NUM.each { |num| cards_with_values[num] = defy_values(num.to_s) }
    cards_with_values.each do |num, value|
      SUITS.each { |suit| @all << Card.new(num.to_s, suit, value.to_i) }
    end
    shuffle
  end

  def shuffle
    @all.shuffle!
  end

  def defy_values(card)
    case card
    # если это цифра, присваиваем значение цифры
    when /\d/ then card.to_i
    # если это король, дама или валет, присваиваем значение 10
    when /[^0-9A]/ then 10
    # если это туз, присваиваем значение 1
    else
      1
    end
  end

  # даем игроку первую карту из колоды. мешать не надо - колода итак помешана
  # до этого. карта уже будет случайной и без sample
  def card
    card = @all.first
    @all -= [card]
    card
  end
end
