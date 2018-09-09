require_relative 'lib/card'
require_relative 'lib/deck'
require_relative 'lib/player'
require_relative 'lib/guest'
require_relative 'lib/dealer'
require_relative 'lib/game'
require_relative 'lib/game_menu'

puts 'Добро пожаловать в игру Black Jack. Как вас зовут?'
name = gets.chomp
puts "#{name}, cыграем?!"
guest = Guest.new(name)
dealer = Dealer.new('Dealer Joe')
game = Game.new(guest, dealer)
GameMenu.new(game)
