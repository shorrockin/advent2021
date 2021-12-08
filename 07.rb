# typed: false
# frozen_string_literal: true
require './utils/boilerplate.rb'
require './utils/intcode.rb'

TEST_INPUT = "16,1,2,0,4,2,7,1,2,14".split(',').map(&:to_i)
ACTUAL_INPUT = AoC::IO.input_file_line.split(',').map(&:to_i)

def simulate(input, formula)
  input.max.times.map do |t| 
    input.sum {|n| formula.call(n, t)}
  end.min
end

AoC.part 1 do
  formula = ->(from, to) {(from - to).abs}
  Assert.equal 37, simulate(TEST_INPUT, formula)
  simulate(ACTUAL_INPUT, formula)
end

AoC.part 2 do
  memoized = ACTUAL_INPUT.max.times.each_with_object(0 => 0) do |num, hash|
    hash[num + 1] = hash[num] + num + 1
  end
  formula = ->(from, to) {memoized[(from - to).abs]}

  Assert.equal 168, simulate(TEST_INPUT, formula)
  simulate(ACTUAL_INPUT, formula)
end
