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

  def my_count(&prc)
    return to_enum(:my_map) unless block_given?
    count = 0
    my_each { |elem| count += 1 if prc.call(elem) }
    count
  end

  def my_map(&prc)
    return to_enum(:my_map) unless block_given?

    mapped = []
    my_each do |elem|
      mapped << prc.call(elem)
    end
    mapped
  end

  def my_inject(*args)
    return to_enum(:my_inject) unless block_given?

    elem = args.size > 0
    accum = elem ? args[0] : self[0]  
    self.drop(elem ? 0 : 1).my_each { |elem| accum = yield(accum, elem) }
    accum
  end

  def multiply_els(array)
    array.my_inject { |mult, elem| mult * elem }
  end

  puts multiply_els([2, 4, 5])

end
