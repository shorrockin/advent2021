# typed: false
# frozen_string_literal: true
require './utils/boilerplate.rb'

AoC.part 1 do
  AoC::IO.input_file.map(&:to_i).each_cons(2).count {|a, b| a < b}
end

AoC.part 2 do
  AoC::IO.input_file.map(&:to_i).each_cons(4).count {|a, b, c, d| (a + b + c) < (b + c + d)}
end
