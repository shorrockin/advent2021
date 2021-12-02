# typed: false
# frozen_string_literal: true
require './utils/boilerplate.rb'
require './utils/coordinates.rb'

AoC.part 1 do
  result = AoC::IO.input_file
    .map(&:split)
    .map {|direction, amount| [direction, amount.to_i]}
    .inject(Flat::Coordinate.new(0, 0)) do |coordinate, line|
      case line[0]
      when 'up' then coordinate.move(Flat::Directions::North, line[1])
      when 'down' then coordinate.move(Flat::Directions::South, line[1])
      when 'forward' then coordinate.move(Flat::Directions::East, line[1])
      else raise "unknown direction: #{direction}"
      end
  end
  result.x * result.y
end

AoC.part 2 do
  coordinate = Flat::Coordinate.new(0, 0)
  aim = 0

  AoC::IO.input_file
    .map(&:split)
    .map {|direction, amount| [direction, amount.to_i]}
    .each do |direction, amount|
      case direction
      when 'down' then aim += amount
      when 'up' then aim -= amount
      when 'forward' then coordinate = coordinate.move(Flat::Directions::East, amount).move(Flat::Directions::South, amount * aim)
      else raise "unknown direction: #{direction}"
      end
  end
  coordinate.x * coordinate.y
end
