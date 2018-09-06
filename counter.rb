module Counter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
  end

  module InstanceMethods
    BJ = 21
    attr_accessor :sum

	def count(hand)
    @sum ||= 0
    # проверка если добавить 11 не будет ли перебора - будет туз 11 или 1?
    hand.last.value = 11 if hand.last.name == 'A' && @sum + 11 <= 20
    @sum += hand.last.value
  end
end
end