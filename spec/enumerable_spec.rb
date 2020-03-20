# spec/enumerable_spec.rb

require './enumerables.rb'

RSpec.describe Enumerable do
  let(:array) {[1, 2, 3]}

  describe "#my_each" do
    it "returns to enumerator when no block given" do
      expect(array.my_each).to be_a(Enumerator)
      expect(array.my_each.to_a).to eq(array)
    end

    it "returns same as each method when block given" do
      expect(array.my_each { |elem| puts "return: #{elem}"}).to eq(array.each {|elem| puts "return: #{elem}"})
    end

    it "raises ArgumentError when argument is given" do
      expect {array.my_each('argument')}.to raise_error(ArgumentError)
    end
  end
end