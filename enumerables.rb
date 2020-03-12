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

    elem = args.size.positive?
    accum = elem ? args[0] : self[0]
    self_drop = drop(elem ? 0 : 1)
    self_drop.my_each { |num| accum = yield(accum, num) }
    accum
  end

  # #1. my_each
  # puts
  # print [1, 2, 3].my_each { |elem| print (elem + 1).to_s + " "} # => 2 3 4
  # puts

  # #2. my_each_with_index
  # puts
  # print [1, 2, 3].my_each_with_index { |elem, idx| puts "#{elem} : #{idx}" } # => 1 : 0, 2 : 1, 3 : 2
  # puts

  # #3. my_select
  # p [1,2,3,8].my_select { |n| n.even? } # => [2, 8]
  # p [0, 2018, 1994, -7].my_select { |n| n > 0 } # => [2018, 1994]
  # p [6, 11, 13].my_select(&:odd?) # => [11, 13]
  # puts

  # # 4. my_all? (example test cases)
  # p [3, 5, 7, 11].my_all? { |n| n.odd? } # => true
  # p [-8, -9, -6].my_all? { |n| n < 0 } # => true
  # p [3, 5, 8, 11].my_all? { |n| n.odd? } # => false
  # p [-8, -9, -6, 0].my_all? { |n| n < 0 } # => false
  # # test cases required by tse reviewer
  # p [1,2,3,4,5].my_all? # => true
  # p [1, 2, 3].my_all?(Integer) # => true
  # p ['dog', 'door', 'rod', 'blade'].my_all?(/d/) # => true
  # p [1, 1, 1].my_all?(1) # => true
  # puts

  # #5. my_any? (example test cases)
  # p [7, 10, 3, 5].my_any? { |n| n.even? } # => true
  # p [7, 10, 4, 5].my_any?() { |n| n.even? } # => true
  # p ["q", "r", "s", "i"].my_any? { |char| "aeiou".include?(char) } # => true
  # p [7, 11, 3, 5].my_any? { |n| n.even? } # => false
  # p ["q", "r", "s", "t"].my_any? { |char| "aeiou".include?(char) } # => false
  # # test cases required by tse reviewer
  # p [1, nil, false].my_any?(1) # => true
  # p [1, nil, false].my_any?(Integer) # => true
  # p ['dog', 'door', 'rod', 'blade'].my_any?(/z/) # => false
  # p [1, 2 ,3].my_any?(1) # => true
  # puts

  # #6. my_none? (example test cases)
  # p [3, 5, 7, 11].my_none? { |n| n.even? } # => true
  # p ["sushi", "pizza", "burrito"].my_none? { |word| word[0] == "a" } # => true
  # p [3, 5, 4, 7, 11].my_none? { |n| n.even? } # => false
  # p ["asparagus", "sushi", "pizza", "apple", "burrito"].my_none? { |word| word[0] == "a" } # => false
  # # test cases required by tse reviewer
  # p [1, 2 ,3].my_none? # => false
  # p [1, 2 ,3].my_none?(String) # => true
  # p [1,2,3,4,5].my_none?(2) # => false
  # p [1, 2, 3].my_none?(4) # => true
  # puts

  # #7. my_count
  # p [1,4,3,8].my_count { |n| n.even? } # => 2
  # p ["DANIEL", "JIA", "KRITI", "dave"].my_count { |s| s == s.upcase } # => 3
  # p ["daniel", "jia", "kriti", "dave"].my_count { |s| s == s.upcase } # => 0
  # puts

  # #8. my_map
  # p [1,2,3].my_map { |n| 2 * n } # => [2,4,6]
  # p ["Hey", "Jude"].my_map { |word| word + "?" } # => ["Hey?", "Jude?"]
  # p [false, true].my_map { |bool| !bool } # => [true, false]
  # puts

  # #9. my_inject
  # p [1,2,3,4].my_inject(10) { |accum, elem| accum + elem} # => 20
  # p [1,2,3,4].my_inject { |accum, elem| accum + elem} # => 10
end
# rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

def multiply_els(array)
  array.my_inject { |mult, elem| mult * elem }
end

puts multiply_els([2, 4, 5])
