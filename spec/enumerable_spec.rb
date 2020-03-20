# spec/enumerable_spec.rb

require './enumerables.rb'

RSpec.describe Enumerable do
  let(:array) {[1, 2, 3]}

  describe "#my_each" do
    it "should return to enumerator when no block given" do
      expect(array.my_each).to be_a(Enumerator)
      expect(array.my_each.to_a).to eq(array)
    end

    it "should return same as each method when block given" do
      expect(array.my_each { |elem| puts "return: #{elem}"}).to eq(array.each {|elem| puts "return: #{elem}"})
    end

    it "should throw an error if given an argument" do
      expect { array.my_each('argument') }.to raise_error(ArgumentError)
    end
  end

  describe "#my_each_with_index" do
    it "should return to enumerator when no block given" do
      expect(array.my_each_with_index).to be_a(Enumerator)
    end

    it "should return same as each_with_index method when block given" do
      expect(array.my_each_with_index { |elem, index| puts "#{elem} : #{index}"}).to eq(array.each_with_index {|elem, index| puts "#{elem} : #{index}"})
    end

    it "should throw an error if given an argument" do
      expect { array.my_each_with_index('argument') }.to raise_error(ArgumentError)
    end

  end
end