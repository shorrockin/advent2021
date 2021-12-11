# typed: false
# frozen_string_literal: true
require './utils/boilerplate.rb'
require './utils/coordinates.rb'

def cycle(grid)
  grid.points.each {|_, data| data[:energy] += 1}
  flashing = grid.select(:energy, 10)
  flash_count = 0

  while flashing.length != 0
    flash_count += flashing.length
    flashing = flashing.map do |coordinate|
      grid.neighbors(coordinate, nil, nil, Flat::Directions::Adjacent).map do |neighbor|
        neighbor_data = grid.at(neighbor)
        neighbor_data[:energy] += 1
        neighbor_data[:energy] == 10 ? neighbor : nil
      end
    end.flatten.compact
  end

  grid.points.each {|_, data| data[:energy] = 0 if data[:energy] > 9}
  flash_count
end

def flash_count(input, cycles=100)
  grid = Flat::Grid.from_lines(input) {|char, _, _| {energy: char.to_i}}
  cycles.times.sum {cycle(grid)}
end

def simul_flash(input)
  grid = Flat::Grid.from_lines(input) {|char, _, _| {energy: char.to_i}}
  cycle_count = 0
  cycle_count += 1 while cycle(grid) != grid.points.length
  cycle_count + 1
end


TEST_INPUT = <<~TEST_INPUT
  5483143223
  2745854711
  5264556173
  6141336146
  6357385478
  4167524645
  2176841721
  6882881134
  4846848554
  5283751526
TEST_INPUT

AoC.part 1 do
  Assert.equal 1656, flash_count(TEST_INPUT)
  flash_count(AoC::IO.input_file)
end

AoC.part 2 do
  Assert.equal 195, simul_flash(TEST_INPUT)
  simul_flash(AoC::IO.input_file)
end
