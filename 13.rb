# typed: false
# frozen_string_literal: true
require './utils/boilerplate.rb'
require './utils/coordinates.rb'

Fold = Struct.new(:horizontal, :position)
Instructions = Struct.new(:folds, :coordinates)

FOLD_PATTERN = /fold along ([xy])=([0-9]*)/
COORD_PATTERN = /([0-9]*),([0-9]*)/

def parse(input)
  input = input.split("\n") if input.is_a?(String)
  folds = []
  coordinates = []

  input.each do |line|
    if line.match?(FOLD_PATTERN)
      coordinate, position = line.scan(FOLD_PATTERN).first
      folds << Fold.new(coordinate == 'y', position.to_i)
    elsif line.match?(COORD_PATTERN)
      x, y = line.scan(COORD_PATTERN).first
      coordinates << Flat::Coordinate.new(x.to_i, y.to_i)
    end
  end

  Instructions.new(folds, coordinates)
end

def fold(instructions, max_folds=nil)
  grid = Flat::Grid.new
  instructions.coordinates.each {|coord| grid.add_coordinate(coord, marked: true, symbol: "#")}
  instructions.folds.each_with_index do |fold, index|
    break if index == max_folds

    # seperate fold point selection from the core loop so we can
    # safely modify the hash
    to_fold = grid.points.select do |coord, data|
      next false if !data[:marked]
      fold.horizontal ? (coord.y >= fold.position) : (coord.x >= fold.position)
    end

    to_fold.each do |coord, _|
      grid.remove_coordinate(coord)

      new_position = case fold.horizontal
      when true then Flat::Coordinate.new(coord.x, fold.position - (coord.y - fold.position))
      when false then Flat::Coordinate.new(fold.position - (coord.x - fold.position), coord.y)
      end
      grid.add_coordinate(new_position, marked: true, symbol: '#')
    end
  end

  grid
end

def count_folds(instructions, max_folds=nil)
  grid = fold(instructions, max_folds)
  grid.points.select {|_, v| v[:marked]}.length
end

TEST_INPUT = <<~TEST_INPUT
  6,10
  0,14
  9,10
  0,3
  10,4
  4,11
  6,0
  6,12
  4,1
  0,13
  10,12
  3,4
  3,0
  8,4
  1,10
  2,14
  8,10
  9,0

  fold along y=7
  fold along x=5
TEST_INPUT

AoC.part 1 do
  instructions = parse(TEST_INPUT)
  Assert.equal 18, instructions.coordinates.length
  Assert.equal 2, instructions.folds.length
  Assert.equal Flat::Coordinate.new(6, 10), instructions.coordinates.first
  Assert.equal Flat::Coordinate.new(9, 0), instructions.coordinates.last
  Assert.equal Fold.new(true, 7), instructions.folds.first
  Assert.equal Fold.new(false, 5), instructions.folds.last
  Assert.equal 17, count_folds(instructions, 1)
  count_folds(parse(AoC::IO.input_file), 1)
end

AoC.part 2 do
  log fold(parse(AoC::IO.input_file)).stringify(filler: ' ', labels: true)
end
