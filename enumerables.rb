module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    i = 0
    size = self.size
    while i < size
      yield self[i]
      i += 1
    end
  end  

end
