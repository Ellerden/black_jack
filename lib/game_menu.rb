require_relative 'game'
require_relative 'guest'
require_relative 'settings'

class GameMenu
  include Settings
  OPTIONS = ['1 - Еще', '2 - Себе', '3 - Вскрываемся',
             '0 - Закончить партию'].freeze
  OPTIONS2 = ['1 - Новая партия', '0 - Выход из игры'].freeze
  OPTIONS3 = ['1 - Начать новую игру', '0 - Выход из игры'].freeze
  MENU_METHODS = { 1 => :guest_hit, 2 => :dealer_turn,
                   3 => :open_cards }.freeze
  MENU_METHODS2 = { 1 => :start_round }.freeze
  MENU_METHODS3 = { 1 => :new_game }.freeze

  attr_reader :game

  def initialize(game)
    @game = game
  end

  def new_game_menu
    print OPTIONS3.join(', ').to_s
    puts
    user_input = gets.chomp.to_i
    send MENU_METHODS3[user_input] || abort
  end

  def new_game
    @game.guest.money = STARTING_MONEY
    @game.dealer.money = STARTING_MONEY
    @game.guest.empty_hand
    @game.dealer.empty_hand
    start_round
  end

  def continue_game_menu
    loop do
      print OPTIONS2.join(', ').to_s
      puts
      input = gets.chomp.to_i
      send MENU_METHODS2[input] || abort
    end
  end

  def start_round
    puts '________________________'
    puts "#{@game.guest.name}, у вас на счету #{@game.guest.money}$, ставка #{BET}$."
    raise 'У вас недостаточно денег на счету' unless @game.guest.enough_money?
    raise "У #{@game.dealer.name} недостаточно денег на счету" unless @game.dealer.enough_money?
    first_bet
    # после того как ставки сделаны первым ходит игрок
    guest_turn_menu
  rescue RuntimeError => e
    puts "Невозможно продолжить игру. #{e.inspect}"
  end

  def first_bet
    puts 'Дилер раздает карты...'
    sleep(1)
    @game.first_bet
    puts "В банке #{BET * 2}$"
    puts "У вас на руках: #{@game.guest.show_hand}."
    puts 'У дилера **, **. '
    puts '________________________'
  end

  def guest_turn_menu
    loop do
      puts "Ваш ход, #{@game.guest.name}. Выберите действие:"
      print OPTIONS.join(', ').to_s
      puts
      input = gets.chomp.to_i
      send MENU_METHODS[input] || break
    end
  end

  def guest_hit
    puts 'Дилер кладет карту...'
    sleep(1)
    puts @game.guest_hit
    puts "У вас на руках: #{@game.guest.show_hand}"
    dealer_turn
  end

  def dealer_turn
    puts 'Ход дилера'
    puts @game.dealer_turn
    puts '________________________'
    showdown if @game.showdown?
  end

  def open_cards
    @game.open_cards
  end

  def showdown
    puts 'Карты на стол... Подсчитаем...'
    puts "У вас на руках: #{@game.guest.show_hand}"
    puts "У дилера на руках: #{@game.dealer.show_hand}"
    puts @game.winner
    continue_game_menu
  end
end
