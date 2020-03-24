# spec/enumerable_spec.rb

require './enumerables.rb'

RSpec.describe Enumerable do
  let(:array) { [1, 2, 3, 4, 5] }
  let(:arr_regex) { %w[dog door rod blade] }
  let(:arr_nil) { [1, nil, false] }
  let(:match_arr) { [1, 1, 1] }
  let(:arr_empty) { [] }
  let(:arr_count) { [1, 1, 1, 2, 3] }

  describe '#my_each' do
    it 'should return to Enumerator if no block given' do
      expect(array.my_each).to be_a(Enumerator)
      expect(array.my_each.to_a).to eq(array)
    end

    it 'should return same as each method if block given' do
      expect(array.my_each { |elem| puts "return: #{elem}" }).to eq(array.each { |elem| puts "return: #{elem}" })
    end

    it 'should throw an error if given an argument' do
      expect { array.my_each('argument') }.to raise_error(ArgumentError)
    end
  end

  describe '#my_each_with_index' do
    it 'should return to Enumerator if no block given' do
      expect(array.my_each_with_index).to be_a(Enumerator)
    end

    it 'should return same as each_with_index method if block given' do
      # rubocop:disable Layout/LineLength
      expect(array.my_each_with_index { |elem, index| puts "#{elem} : #{index}" }).to eq(array.each_with_index { |elem, index| puts "#{elem} : #{index}" })
      # rubocop:enable Layout/LineLength
    end

    it 'should throw an error if given an argument' do
      expect { array.my_each_with_index('argument') }.to raise_error(ArgumentError)
    end
  end

  describe '#my_select' do
    arr_even = [1, 2, 3, 8]
    arr_odd = [6, 11, 13]
    odd = [11, 13]
    array = [3, 5, 'A', 'B']

    it 'should return to Enumerator if no block given' do
      expect(arr_even.my_select).to be_a(Enumerator)
    end

    it 'when Array given should return an Array' do
      expect(arr_even.my_select(&:even?)).to be_an(Array)
    end

    it 'when Array given should return an Array with selected elements' do
      expect(arr_odd.my_select(&:odd?)).to eq(odd)
    end

    it 'if no elements match should return empty Array' do
      expect(array.my_select { |elem| elem == 'x' }).to eq([])
    end

    it 'should throw an error if given an argument' do
      expect { array.my_select('argument') }.to raise_error(ArgumentError)
    end
  end

  describe '#my_all?' do
    it 'returns true if all of the collection matches the Regex' do
      expect(arr_regex.my_all?(/d/)).to eq(true)
    end

    it 'returns true if at least one of the collection is not false or nil' do
      expect(arr_nil.my_any?(1)).to eq(true)
    end

    it 'returns true if all of the collection is a member of such class' do
      expect(array.my_all?(Integer)).to eq(true)
    end

    it 'returns true if all of the collection matches the pattern' do
      expect(match_arr.my_all?(1)).to eq(true)
    end

    it 'should return true if all elements matches the block condition' do
      expect(arr_regex.my_all? { |elem| elem.length >= 3 }).to eq(true)
    end

    it 'if empty array is given should return true' do
      expect(arr_empty.my_all?).to eq(true)
    end
  end

  describe '#my_any?' do
    it 'should return true if at least one of the collection is not false or nil' do
      expect(arr_nil.my_any?(1)).to eq(true)
    end

    it 'should return true if at least one of the collection is a member of such class' do
      expect(arr_nil.my_any?(Integer)).to eq(true)
    end

    it 'should return false if none of the collection matches the Regex' do
      expect(arr_regex.my_any?(/z/)).to eq(false)
    end

    it 'should return false if none of the collection matches the pattern' do
      expect(array.my_any?(1)).to eq(true)
    end

    it 'should return true if any elements matches the block condition' do
      expect(arr_regex.my_any? { |elem| elem.length >= 3 }).to eq(true)
    end

    it 'if empty array is given should return false' do
      expect(arr_empty.my_any?).to eq(false)
    end
  end

  describe '#my_none?' do
    it 'should return true only if none of the collection members is true' do
      expect(array.my_none?).to eq(false)
    end

    it 'should return true if none of the collection is a member of such class' do
      expect(array.my_none?(String)).to eq(true)
    end

    it 'should return true only if none of the collection matches the Regex' do
      expect(array.my_none?(2)).to eq(false)
    end

    it 'should return true only if none of the collection matches the pattern' do
      expect(array.my_none?(4)).to eq(false)
    end

    it 'should return true if none elements matches the block condition' do
      expect(arr_regex.my_none? { |elem| elem.length >= 3 }).to eq(false)
    end

    it 'if empty array is given should return true' do
      expect(arr_empty.my_none?).to eq(true)
    end
  end

  describe '#count' do
    it 'should return the number of items in enum through enumeration' do
      expect(array.my_count).to eq(5)
    end

    it 'should count the number of items in enum that are equal to item if an argument is given' do
      expect(arr_count.my_count(1)).to eq(3)
    end

    it 'should return number of elements that matches the block condition' do
      expect(array.my_count(&:even?)).to eq(2)
    end
  end

  describe '#my_map' do
    it 'should return to Enumerator if no block given' do
      expect(array.my_each).to be_a(Enumerator)
    end

    it 'if block given should return new array matching block conditions' do
      expect(array.my_map { |elem| elem + 3 }).to eq([4, 5, 6, 7, 8])
    end

    it 'if both a proc and a block are given, only execute the pro' do
      my_proc = proc { |num| num > 2 }
      expect(array.my_map(my_proc) { |num| num > 2 }).to eq([false, false, true, true, true])
    end

    it 'should return a new array containing classes of each element in the array given' do
      expect(arr_regex.my_map(&:class)).to eq([String, String, String, String])
    end
  end

  describe '#my_inject' do
    # rubocop:disable Layout/LineLength
    it 'When a symbol is specified should combine each element of the collection by applying the symbol as a named method' do
      expect(array.my_inject('+')).to eq(15)
    end

    it 'When a symbol and a patern are specified should combine each element of the collection by applying the symbol as a named method based on the initial patern' do
      expect((5..10).my_inject(2, :*)).to eq(302_400)
    end
    # rubocop:enable Layout/LineLength

    it 'when block given should return the result of the block' do
      expect((5..10).my_inject(4) { |prod, n| prod * n }).to eq(604_800)
    end
  end

  describe '#multiply_els' do
    it 'it should multiply all the elements of the array together by using #my_inject method' do
      expect(multiply_els([2, 4, 5])).to eql(40)
    end
  end
end
