# typed: false
# frozen_string_literal: true
require './utils/boilerplate.rb'
require './utils/coordinates.rb'

Line = Struct.new(:from, :to) do
  def diagonal?; from.y != to.y && from.x != to.x; end

  def coordinates
    step = Flat::Coordinate.new(to.x <=> from.x, to.y <=> from.y)
    result = [to]
    current = Flat::Coordinate.new(from.x, from.y)

    while current != to
      result << current
      current = current.move(step)
    end

    result
  end
end

def parse(input)
  input.map do |line|
    from_str, to_str = line.split(' -> ')
    from = from_str.split(',').map(&:to_i)
    to = to_str.split(',').map(&:to_i)
    Line.new(Flat::Coordinate.new(from[0], from[1]), Flat::Coordinate.new(to[0], to[1]))
  end
end

def calculate_overlap(lines, diagonal: false)
  grid = Flat::Grid.new
  lines.each do |line|
    next if line.diagonal? && !diagonal
    line.coordinates.each do |coordinate|
      grid.add_coordinate(coordinate, count: grid.get(coordinate, :count, 0) + 1)
    end
  end

  grid.points.sum {|_, properties| properties[:count] > 1 ? 1 : 0}
end

RAW_TEST_INPUT = <<~RAW_TEST_INPUT
  0,9 -> 5,9
  8,0 -> 0,8
  9,4 -> 3,4
  2,2 -> 2,1
  7,0 -> 7,4
  6,4 -> 2,0
  0,9 -> 2,9
  3,4 -> 1,4
  0,0 -> 8,8
  5,5 -> 8,2
RAW_TEST_INPUT
TEST_INPUT = RAW_TEST_INPUT.split("\n")

AoC.part 1 do
  lines = parse(TEST_INPUT)
  Assert.equal 10, lines.length
  Assert.equal 0, lines.first.from.x
  Assert.equal 9, lines.first.from.y
  Assert.equal 5, lines.first.to.x
  Assert.equal 9, lines.first.to.y
  Assert.equal 5, lines.last.from.x
  Assert.equal 5, lines.last.from.y
  Assert.equal 5, calculate_overlap(lines)

  calculate_overlap(parse(AoC::IO.input_file))
end

AoC.part 2 do
  Assert.equal 12, calculate_overlap(parse(TEST_INPUT), diagonal: true)
  calculate_overlap(parse(AoC::IO.input_file), diagonal: true)
end
