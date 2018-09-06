require_relative 'card'
require_relative 'deck'
require_relative 'player'
require_relative 'guest'
require_relative 'counter'
require_relative 'dealer'
require_relative 'game_menu'


puts "Добро пожаловать в игру Black Jack. Как вас зовут?"
name = gets.chomp
puts "#{name}, cыграем!"
guest = Guest.new(name)
dealer = Dealer.new('Dealer Joe')
deck = Deck.new
GameMenu.new(deck, guest, dealer)





=begin
deck = Deck.new
guest = Guest.new
dealer = Dealer.new
puts "Добро пожаловать в игру Black Jack. У вас на счету #{guest.money}$. Сыграем?"
puts "Раздаю карты..."
sleep(2)
guest.hit(deck.card)
dealer.hit(deck.card)
puts "У вас на руках: #{guest.last_card}"
puts "У дилера: #{dealer.last_card}"

=end



=begin
loop do
puts "Что вы хотите делать дальше?"
puts "1 - Еще. 2 - Cебе. 3 - Вскрываемся. 0 - Закончить"
input = gets.chomp.to_i

case input
when 1 then guest.hit(deck.card)
  puts "Вам пришла: #{guest.last_card}"
  puts "Теперь у вас на руках #{guest.hand[0].name} #{guest.hand[0].suit}"
when 2 then
  choice = dealer.decide
  puts choice
  if choice == :hold
    puts "Мне хватит"
  else
    dealer.hit(deck.card)
  puts "Дилер взял карту"
  end
when 3 then puts guest.show
  puts dealer.show
else
  break
end
end

def result
  if dealer

end

=end
# когда игра заканчивается, то
# юзер может играть если у него есть деньги


