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

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def my_all?(arg = nil, &prc)
    return true if !block_given? && arg.nil? && include?(nil) == false && include?(false) == false
    return false unless block_given? || !arg.nil?

    if block_given?
      my_each { |elem| return false if prc.call(elem) == false }
    elsif arg.class == Regexp
      my_each { |elem| return false if arg.match(elem).nil? }
    elsif arg.class <= Numeric || arg.class <= String
      my_each { |elem| return false if elem != arg }
    else
      my_each { |elem| return false if (elem.is_a? arg) == false }
    end
    true
  end

  def my_any?(arg = nil, &prc)
    return true if !block_given? && arg.nil? && my_each { |elem| return true if elem == true } && empty? == false
    return false unless block_given? || !arg.nil?

    if block_given?
      my_each { |elem| return true if prc.call(elem) }
    elsif arg.class == Regexp
      my_each { |elem| return true unless arg.match(elem).nil? }
    elsif arg.class <= Numeric || arg.class <= String
      my_each { |elem| return true if elem == arg }
    else
      my_each { |elem| return true if elem.class <= arg }
    end
    false
  end

  def my_none?(arg = nil, &prc)
    return true if !block_given? && arg.nil? && my_each { |elem| return false if elem == true }
    return false unless block_given? || !arg.nil?

    if block_given?
      my_each { |elem| return false if prc.call(elem) }
    elsif arg.class == Regexp
      my_each { |elem| return false unless arg.match(elem).nil? }
    elsif arg.class <= Numeric || arg.class <= String
      my_each { |elem| return false if elem == arg }
    else
      my_each { |elem| return false if elem.class <= arg }
    end
    true
  end

  def my_count(arg = nil, &prc)
    count = 0
    my_each do |elem|
      if block_given?
        count += 1 if prc.call(elem)
      elsif !arg.nil?
        count += 1 if elem == arg
      else
        count = length
      end
    end
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

  def my_inject(memo = nil, sym = nil, &prc)
    memo = memo.to_sym if memo.is_a?(String) && !sym && !prc

    if memo.is_a?(Symbol) && !sym
      prc = memo.to_proc
      memo = nil
    end

    sym = sym.to_sym if sym.is_a?(String)
    prc = sym.to_proc if sym.is_a?(Symbol)

    my_each { |elem| memo = memo.nil? ? elem : prc.yield(memo, elem) }
    memo
  end
end
# rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

def multiply_els(array)
  array.my_inject { |mult, elem| mult * elem }
end

puts multiply_els([2, 4, 5]) # => 40
