# typed: false
# frozen_string_literal: true
require './utils/boilerplate.rb'
require './utils/coordinates.rb'

def parse(input)
  input = input.split("\n") if input.is_a?(String)
  Flat::Grid.from_lines(input) {|char, _, _| {value: char.to_i}}
end

def low_points(grid)
  grid.points.select do |coord|
    grid.get(coord, :value) < grid.neighbors(coord).map {|c| grid.get(c, :value)}.min
  end.keys
end

def sum_low_points(grid)
  low_points(grid).sum {|coord| grid.get(coord, :value) + 1}
end

def multiply_basins(grid)
  low_points(grid)
    .map {|coord| basin_coords(grid, coord).length}
    .sort
    .reverse
    .take(3)
    .inject(&:*)
end

def basin_coords(grid, at, calculated=[at])
  neighbors = grid.neighbors(at)
    .reject {|c| grid.get(c, :value) == 9}
    .reject {|c| calculated.include?(c)}
  calculated += neighbors
  neighbors.each {|neighbor| calculated = basin_coords(grid, neighbor, calculated)}
  calculated
end

TEST_INPUT = <<~TEST_INPUT
  2199943210
  3987894921
  9856789892
  8767896789
  9899965678
TEST_INPUT

AoC.part 1 do
  Assert.equal 15, sum_low_points(parse(TEST_INPUT))
  sum_low_points(parse(AoC::IO.input_file))
end

AoC.part 2 do
  Assert.equal 1134, multiply_basins(parse(TEST_INPUT))
  multiply_basins(parse(AoC::IO.input_file))
end
