require_relative 'player'
require_relative 'card'
require_relative 'deck'
require_relative 'guest'
require_relative 'dealer'
require_relative 'settings'

class Game
  include Settings
  DEALER_MASK = '*******'.freeze
  attr_reader :deck, :guest, :dealer, :menu, :guest_ready_to_open, :dealer_chosen

  def initialize(guest, dealer)
    @guest = guest
    @dealer = dealer
    new_round
  end

  def roll_to_default
    @deck = Deck.new
    @guest_ready_to_open = false
    @dealer_chosen = false
    @guest.empty_hand
    @dealer.empty_hand
  end

  # и пользователю и дилеру раздается по 2 карты
  def new_round
    # берется новая колода, все значения обнуляются кроме суммы перед каждым раундом.
    roll_to_default
    money_valid?
    2.times do
      @guest.hit(@deck.card)
      @dealer.hit(@deck.card)
    end
  end

  def money_valid?
    raise 'У вас недостаточно денег на счету' unless @guest.enough_money?
    raise "У #{@game.dealer.name} недостаточно денег на счету" unless @dealer.enough_money?
    true
  end

  def guest_hand
    @guest.show_hand
  end

  def dealer_hand
    # если ход дилера уже был то можно показывать по Вскрываемся карты дилера
    @dealer_chosen ? @dealer.show_hand : DEALER_MASK
  end

  def dealer_turn
    choice = @dealer.decide
    @dealer_chosen = true
    case choice
    when :hold
      # 'Дилеру хватит'
    when :hit
      @dealer.hit(deck.card) if @dealer.hand.size < MAX_CARDS
      # 'Дилер взял карту'
    end
  end

  def showdown?
    # eсли у пользователя на руках 3 карты или он до этого захотел вскрываться и дилер уже ходил
    return true if @dealer_chosen && (@guest_ready_to_open || @guest.hand.size == MAX_CARDS)
    false
  end

  def guest_hit
    return unless @guest.hand.size < MAX_CARDS
    @guest.hit(@deck.card)
  end

  def guest_pass_turn
    dealer_turn
  end

  def guest_open_cards
    @guest_ready_to_open = true
    dealer_turn unless @dealer_chosen
  end

  def guest_won?
    true if @guest.sum > @dealer.sum && !@guest.lost? ||
            @guest.sum < @dealer.sum && @dealer.lost? && !@guest.lost?
  end

  def dealer_won?
    true if @guest.sum < @dealer.sum && !@dealer.lost? ||
            @guest.sum > @dealer.sum && @guest.lost? && !@dealer.lost?
  end

  def declare_winner
    @guest.bet
    @dealer.bet
    if guest_won?
      @guest.money += BET * 2
    elsif dealer_won?
      @dealer.money += BET * 2
    else
      @guest.money += BET
      @dealer.money += BET
    end
  end
end
