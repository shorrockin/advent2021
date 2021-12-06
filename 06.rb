# typed: false
# frozen_string_literal: true
require './utils/boilerplate.rb'

TEST_INPUT = "3,4,3,1,2"

def simulate(initial_str, days:)
  initial = initial_str.split(',').map(&:to_i)
  current = 9.times.map {|i| [i, initial.count {|v| v == i}]}.to_h
  days.times do
    new_fish = current[0]
    8.times {|val| current[val] = current[val + 1]}
    current[6] += new_fish
    current[8] = new_fish
  end
  current.values.sum
end

AoC.part 1 do
  Assert.equal 26, simulate(TEST_INPUT, days: 18)
  Assert.equal 5934, simulate(TEST_INPUT, days: 80)
  simulate(AoC::IO.input_file.first, days: 80)
end

AoC.part 2 do
  Assert.equal 26984457539, simulate(TEST_INPUT, days: 256)
  simulate(AoC::IO.input_file.first, days: 256)
end
