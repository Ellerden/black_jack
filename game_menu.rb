
require_relative 'player'
require_relative 'card'
require_relative 'deck'
require_relative 'guest'
require_relative 'counter'
require_relative 'dealer'

class GameMenu
  OPTIONS = ['1 - Еще', '2 - Себе', '3 - Вскрываемся', '0 - Выход из игры']
  OPTIONS2 = ['1 - Новая партия', '0 - Выход из игры']
  OPTIONS3 = ['1 - Обнулить результат и начать заново', '0 - Выход из игры']
  MENU_METHODS = { 1 => :guest_hit, 2 => :dealer_turn,
                   3 => :showdown }.freeze
  MENU_METHODS2 = { 1 => :start_round }.freeze
  MENU_METHODS3 = { 1 => :reset }.freeze
  BET = 10

attr_accessor :deck, :guest, :dealer, :result

  def initialize(deck, guest, dealer)
    @deck = deck
    @guest = guest
    @dealer = dealer
    start_round
  end

  def start_round
    @guest.empty_hand
    @dealer.empty_hand
    puts "#{@guest.name}, у вас на счету #{@guest.money}$, ставка #{BET}$."
    puts "@guest.enough_money #{@guest.enough_money?}"
    puts  "@dealer.enough_money? #{@dealer.enough_money?}"
    raise "У вас не хватает денег на счету" unless @guest.enough_money?
    raise "У #{@dealer.name} не хватает денег на счету" unless @dealer.enough_money?
    first_bet
    guest_turn
  rescue RuntimeError => e
    puts "Невозможно продолжить игру. #{e.inspect}"
    puts OPTIONS3
    user_input = gets.chomp.to_i
    send MENU_METHODS3[user_input] || abort
  end
# и пользователю и дилеру раздается по 2 карты
def first_bet
  puts "Дилер раздает карты..."
  sleep(1)
  # и пользователю и дилеру раздается по 2 карты
  2.times do
    guest.hit(@deck.card)
    dealer.hit(@deck.card)
  end
  guest.bet
  dealer.bet
  puts "В банке #{BET * 2}$"
  puts "У дилера: [**, **] #{@dealer.show_hand}. Сумма очков: #{@dealer.sum}"
  puts "У вас на руках: #{@guest.show_hand}. Сумма очков: #{@guest.sum}"
end

  def guest_turn
    loop do
      puts OPTIONS
      input = gets.chomp.to_i
      send MENU_METHODS[input] || break
    end
  end

  def dealer_turn
    choice = dealer.decide
    case choice
    when :hold
      puts "Дилеру хватит"
      showdown if @guest.hand.size == 3
    when :hit
      dealer.hit(deck.card) if @dealer.hand.size < 3
      puts "Дилер взял карту"
      showdown if @guest.hand.size == 3
    end
  end

  def reset
    @guest.money = 100
    @dealer.money = 100
    @guest.empty_hand
    @dealer.empty_hand
    start_round
  end

  def guest_hit
    if @guest.hand.size < 3
      puts "Дилер кладет карту... это"
      sleep(1)
      @guest.hit(@deck.card)
      puts "#{@guest.last_card}"
      puts "Теперь у вас на руках #{@guest.show_hand}. Сумма очков: #{@guest.sum}"
      # игроку может прийти только одна карта - потом ход переходит к дилеру
      # если игрок пропустил ход и не брал карту, то ход сразу переходит к дилеру
      puts "Ход переходит к дилеру"
      dealer_turn
    else
      puts "Карты брать больше нельзя, на руках может быть не больше 3-х карт."
    end
  end

  def winner
    if guest.sum > dealer.sum && !guest.lost?
      guest.money += BET * 2
      result = "Вы выиграли #{BET}$. У вас на счету #{guest.money}"
    elsif guest.sum < dealer.sum && !dealer.lost?
      dealer.money += BET * 2
      result = "Вы проиграли #{BET}$. У вас на счету #{guest.money}"
    else
      guest.money += BET
      dealer.money += BET
      result = "Ничья. У вас на счету #{guest.money}"
    end
  end

  def showdown
    puts "Карты на стол... Посчитаем..."
    puts "У вас на руках: #{@guest.show_hand}. Сумма очков: #{@guest.sum}"
    puts "У дилера на руках: #{@dealer.show_hand}. Сумма очков: #{@dealer.sum}"
    puts winner
    after_showdown
  end

  def after_showdown
    loop do
      puts OPTIONS2
      input = gets.chomp.to_i
      send MENU_METHODS2[input] || abort
    end
  end

end
