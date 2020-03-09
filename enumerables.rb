


  def my_each(num)
    i = 0
    while i < num.size
      yield num[i]
      i += 1
    end
  end



my_each([1,2,3]) do |num| puts num * 2 end

