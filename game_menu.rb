
require_relative 'player'
require_relative 'card'
require_relative 'deck'
require_relative 'guest'
require_relative 'counter'
require_relative 'dealer'

class GameMenu
  OPTIONS = ['1 - Еще', '2 - Себе', '3 - Вскрываемся', '0 - выход из игры']
  MENU_METHODS = { 1 => :guest_hit, 2 => :dealer_turn,
                   3 => :showdown}.freeze
  MENU = {1 => :reset}.freeze
  BET = 10

attr_accessor :deck, :guest, :dealer, :result

  def initialize(deck, guest, dealer)
    @deck = deck
    @guest = guest
    @dealer = dealer
    start_round
  end

    def guest_turn
    loop do
      puts OPTIONS
      input = gets.chomp.to_i
      send MENU_METHODS[input] || break
    end
  end

  def start_round
    puts "#{@guest.name}, у вас на счету #{@guest.money}$, ставка #{BET}$."
    puts "@guest.enough_money #{@guest.enough_money?}"
    puts  "@dealer.enough_money? #{@dealer.enough_money?}"
    raise "У вас не хватает денег на счету" unless @guest.enough_money?
    raise "У #{@dealer.name} не хватает денег на счету" unless @dealer.enough_money?
    first_bet
    guest_turn
  rescue RuntimeError => e
    puts "Невозможно продолжить игру. #{e.inspect}"
    puts 'Начать игру заново? 1 - Да. 0 - Выйти'
    user_input = gets.chomp.to_i
    send MENU[user_input] || abort
  end
# и пользователю и дилеру раздается по 2 карты
def first_bet
  puts "Дилер раздает карты..."
  sleep(1)
  2.times do
    guest.hit(@deck.card)
    dealer.hit(@deck.card)
  end

  guest.bet
  dealer.bet
  puts "У вас на руках: #{@guest.show}. Сумма очков: #{@guest.sum}"
  puts "У дилера: ** ** #{@dealer.show}. Сумма очков: #{@dealer.sum}"
end

   # puts "У вас на счету #{guest.money}$."
    # и пользователю и дилеру раздается по 2 карты
    #puts "У дилера: #{dealer.last_card}"

  def reset
    guest.reset_game
    dealer.reset_game
    start_round
  end

  def guest_hit
    @guest.hit(@deck.card)
    puts "Дилер кладет карту... это"
    sleep(1)
    puts "#{guest.last_card}"
    puts "Теперь у вас на руках #{guest.show}"
    # игроку может прийти только одна карта - потом ход переходит к дилеру
    # если игрок пропустил ход и не брал карту, то ход сразу переходит к дилеру
    dealer_turn
  end

  def dealer_turn
    choice = dealer.decide
    if choice == :hold
      puts "Дилеру хватит"
    else
      dealer.hit(deck.card)
      puts "Дилер взял карту"
    end
  end

  def winner
    if guest.sum > dealer.sum && !guest.lost?
      guest.money += BET * 2
      dealer.money -= BET
      result = "Вы выиграли #{BET}$. У вас на счету #{guest.money}"
    elsif guest.sum < dealer.sum && !dealer.lost?
      dealer.money += BET * 2
      guest.money -= 10
      result = "Вы проиграли #{BET}$. У вас на счету #{guest.money}"
    else
      guest.money += BET
      dealer.money += BET
      result = "Ничья. У вас на счету #{guest.money}"
    end
  end

  def showdown
    puts guest.show
    puts dealer.show
    puts winner
  end

end
