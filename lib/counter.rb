require_relative 'settings'

module Counter
  include Settings
  attr_accessor :sum

  def count(hand)
    @sum ||= 0
    # проверка если добавить 11 не будет ли перебора - будет туз 11 или 1?
    hand.last.value = 11 if hand.last.name == 'A' && @sum + 11 <= BJ
    @sum += hand.last.value
  end
end
