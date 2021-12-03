# typed: false
# frozen_string_literal: true
require './utils/boilerplate.rb'

def count_ones(input, bit_position)
  input.count {|line| line[bit_position] == '1'}
end

def power_consumption(input, common, otherwise)
  input.first.length.times.map do |bit_position|
    char_count = count_ones(input, bit_position)
    char_count > (input.length / 2) ? common : otherwise
  end.join.to_i(2)
end

def gamma(input)
  power_consumption(input, '1', '0')
end

def epsilon(input)
  power_consumption(input, '0', '1')
end

def life_support(input, common, otherwise)
  bit_position = 0

  while input.length > 1
    one_count    = count_ones(input, bit_position)
    zero_count   = input.length - one_count
    start_with   = (one_count >= zero_count) ? common : otherwise
    input        = input.select {|line| line[bit_position] == start_with}
    bit_position = (bit_position + 1) % input.first.length
  end

  input.first.to_i(2)
end

def oxygen(input)
  life_support(input, '1', '0')
end

def co2(input)
  life_support(input, '0', '1')
end

TEST_INPUT = <<~TEST_DATA
  00100
  11110
  10110
  10111
  10101
  01111
  00111
  11100
  10000
  11001
  00010
  01010
TEST_DATA

AoC.part 1 do
  Assert.equal 22, gamma(TEST_INPUT.split("\n"))
  Assert.equal 9, epsilon(TEST_INPUT.split("\n"))
  gamma(AoC::IO.input_file) * epsilon(AoC::IO.input_file)
end

AoC.part 2 do
  Assert.equal 23, oxygen(TEST_INPUT.split("\n"))
  Assert.equal 10, co2(TEST_INPUT.split("\n"))
  oxygen(AoC::IO.input_file) * co2(AoC::IO.input_file)
end
