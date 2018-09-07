class Card
  attr_accessor :name, :suit, :value

  def initialize(name, suit)
    @name = name
    @suit = suit
    set_value
  end

  private

  def set_value
    @value = case @name
             # если это цифра, присваиваем значение цифры
             when /\d/ then @name.to_i
             # если это король, дама или валет, присваиваем значение 10
             when /[^0-9A]/ then 10
             # если это туз, присваиваем значение 1
             else
               1
             end
  end
end
