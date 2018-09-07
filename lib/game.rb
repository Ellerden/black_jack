require_relative 'player'
require_relative 'card'
require_relative 'deck'
require_relative 'guest'
require_relative 'counter'
require_relative 'dealer'
require_relative 'settings'
require_relative 'game_menu'

class Game
  include Settings

  attr_reader :deck, :guest, :dealer
  attr_accessor :guest_ready_to_open, :dealer_chosen, :menu

  def initialize(deck, guest, dealer)
    @guest = guest
    @dealer = dealer
    @deck = deck
    @menu = GameMenu.new(self)
    # после создания инстанса меню, вызываем новую игру
    @menu.new_game
  end

  def roll_to_default
    @guest_ready_to_open = false
    @dealer_chosen = false
    @guest.empty_hand
    @dealer.empty_hand
  end

  # и пользователю и дилеру раздается по 2 карты
  def first_bet
    # все значения обнуляются кроме суммы перед каждым раундом
    roll_to_default
    2.times do
      @guest.hit(@deck.card)
      @dealer.hit(@deck.card)
    end
    @guest.bet
    @dealer.bet
  end

  def dealer_turn
    choice = @dealer.decide
    @dealer_chosen = true
    case choice
    when :hold
      'Дилеру хватит'
      # eсли у пользователя на руках 3 карты или он до этого захотел вскрываться
    when :hit
      @dealer.hit(deck.card) if @dealer.hand.size < MAX_CARDS
      'Дилер взял карту'
    end
  end

  def showdown?
    true if @guest.hand.size == MAX_CARDS || @guest_ready_to_open
  end

  def open_cards
    @guest_ready_to_open = true
    @dealer_chosen ? @menu.showdown : @menu.dealer_turn
  end

  def guest_hit
    # Больше трех карт на руках быть не может
    return unless @guest.hand.size < MAX_CARDS
    @guest.hit(@deck.card)
    @guest.last_card
  end

  def guest_won?
    true if @guest.sum > @dealer.sum && !@guest.lost? ||
            @guest.sum < @dealer.sum && @dealer.lost? && !@guest.lost?
  end

  def dealer_won?
    true if @guest.sum < @dealer.sum && !@dealer.lost? ||
            @guest.sum > @dealer.sum && @guest.lost? && !@dealer.lost?
  end

  def winner
    if guest_won?
      @guest.money += BET * 2
      "Вы выиграли #{BET}$. У вас на счету #{@guest.money}$"
    elsif dealer_won?
      @dealer.money += BET * 2
      "Вы проиграли #{BET}$. У вас на счету #{@guest.money}$"
    else
      @guest.money += BET
      @dealer.money += BET
      "Ничья. У вас на счету #{@guest.money}$"
    end
  end
end
