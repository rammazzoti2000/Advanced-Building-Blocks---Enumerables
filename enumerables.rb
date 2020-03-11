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

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    i = 0
    my_each do |elem|
      yield(elem, i)
      i += 1
    end
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    select = []
    my_each { |elem| select << elem if yield(elem) }
    select
  end

  def my_all?(&prc)
    my_each { |elem| return false if prc.call(elem) == false }
    true
  end

  def my_any?(&prc)
    my_each { |elem| return true if prc.call(elem) }
    false
  end

  def my_none?(&prc)
    my_each { |elem| return false if prc.call(elem) }
    true
  end

end
