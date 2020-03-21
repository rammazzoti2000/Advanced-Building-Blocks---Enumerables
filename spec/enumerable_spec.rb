# spec/enumerable_spec.rb

require './enumerables.rb'

RSpec.describe Enumerable do
  let(:array) { [1, 2, 3] }

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
end
