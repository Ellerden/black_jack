require_relative 'game'
require_relative 'guest'
require_relative 'settings'

class GameMenu
  include Settings
  GUEST_TURN_MENU = ['1 - Еще', '2 - Себе', '3 - Вскрываемся',
                     '0 - Закончить партию'].freeze
  ROUND_MENU = ['1 - Новая партия', '0 - Выход из игры'].freeze
  GAME_MENU = ['1 - Начать новую игру', '0 - Выход из игры'].freeze
  GUEST_TURN_MENU_METHODS = { 1 => :guest_hit, 2 => :dealer_turn,
                              3 => :open_cards }.freeze
  ROUND_MENU_METHODS = { 1 => :new_round }.freeze
  GAME_MENU_METHODS = { 1 => :new_game }.freeze

  attr_reader :game

  def initialize(game)
    @game = game
    new_round
  end

  def new_round
    puts '________________________'
    puts "#{@game.guest.name}, у вас на счету #{@game.guest.money}$, ставка #{BET}$."
    puts 'Дилер раздает карты...'
    sleep(0.5)
    @game.new_round
    puts "У вас на руках #{@game.guest_hand}"
    puts "У дилера #{@game.dealer_hand}"
    # после того как ставки сделаны первым ходит игрок
    guest_turn_menu
  rescue RuntimeError => e
    puts "Невозможно продолжить игру. #{e.inspect}"
  end

  def new_game_menu
    print GAME_MENU.join(', ').to_s
    puts
    user_input = gets.chomp.to_i
    send GAME_MENU_METHODS[user_input] || abort
  end

  def round_menu
    loop do
      print ROUND_MENU.join(', ').to_s
      puts
      input = gets.chomp.to_i
      send ROUND_MENU_METHODS[input] || abort
    end
  end

  def guest_turn_menu
    loop do
      puts "Ваш ход, #{@game.guest.name}. Выберите действие:"
      print GUEST_TURN_MENU.join(', ').to_s
      puts
      input = gets.chomp.to_i
      send GUEST_TURN_MENU_METHODS[input] || break
    end
  end

  def guest_hit
    puts 'Дилер кладет карту...'
    sleep(0.5)
    @game.guest_hit
    puts @game.guest.last_card
    puts "У вас на руках: #{@game.guest_hand}"
    puts 'Ход переходит к дилеру'
    dealer_turn
  end

  def dealer_turn
    puts 'Дилер ходит'
    @game.dealer_turn
    puts '________________________'
    showdown if @game.showdown?
  end

  def open_cards
    @game.guest_open_cards
    showdown if @game.showdown?
  end

  def showdown
    puts 'Карты на стол... Подсчитаем...'
    puts "У вас на руках: #{@game.guest.show_hand}"
    puts "У дилера на руках: #{@game.dealer.show_hand}"
    @game.declare_winner
    if @game.guest_won?
      puts "Вы выиграли #{BET}$. У вас на счету #{@game.guest.money}$"
    elsif @game.dealer_won?
      puts "Вы проиграли #{BET}$. У вас на счету #{@game.guest.money}$"
    else
      puts "Ничья. У вас на счету #{@game.guest.money}$"
    end
    round_menu
  end
end
