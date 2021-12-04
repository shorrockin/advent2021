# typed: false
# frozen_string_literal: true
require './utils/boilerplate.rb'

class Bingo
  attr_accessor :draws
  attr_accessor :board_count
  attr_accessor :boards

  def initialize(input)
    @draws = input[0].split(',').map(&:to_i)
    @board_count = (input.length - 1) / 6
    @boards = []

    board_count.times do |board|
      numbers = 5.times.map do |row|
        input[(5 * board) + board + 2 + row].split(' ').map(&:strip).map(&:to_i)
      end

      @boards << Board.new(board, numbers, Array.new(5) {Array.new(5, false)})
    end
  end

  def run(first_winner=true)
    last_board = nil
    last_number = nil

    draws.each do |number|
      boards.each do |board|
        next if board.won
        next if !board.mark(number)

        if first_winner
          return [board, number]
        else
          last_board = board
          last_number = number
        end
      end
    end
    [last_board, last_number]
  end
end

class Board
  attr_accessor :id
  attr_accessor :numbers
  attr_accessor :marked
  attr_accessor :won

  def initialize(id, numbers, marked)
    @id = id
    @numbers = numbers
    @marked = marked
    @won = false
  end

  def mark(number)
    @numbers.each_with_index do |row, row_number|
      column = row.index(number)
      @marked[row_number][column] = true unless column.nil?
    end
    @won = winning?
  end

  def winning?
    @numbers.each_with_index do |_, row_number|
      return true if !@marked[row_number].include?(false) # horizontal match
      return true if @marked.all? {|col| col[row_number]} # vertical match
    end
    false
  end

  def sum_unmarked
    sum = 0
    @marked.each_with_index do |row, row_number|
      row.each_with_index do |col, col_number|
        sum += @numbers[row_number][col_number] if !col
      end
    end
    sum
  end
end

RAW_TEST_DATA = <<~TEST_DATA
  7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

  22 13 17 11  0
  8  2 23  4 24
  21  9 14 16  7
  6 10  3 18  5
  1 12 20 15 19

  3 15  0  2 22
  9 18 13 17  5
  19  8  7 25 23
  20 11 10 24  4
  14 21 16 12  6

  14 21 17 24  4
  10 16 15  9 19
  18  8 23 26 20
  22 11 13  6  5
  2  0 12  3  7
TEST_DATA
TEST_DATA = RAW_TEST_DATA.split("\n")

AoC.part 1 do
  bingo = Bingo.new(TEST_DATA)

  Assert.equal 27, bingo.draws.length
  Assert.equal 7, bingo.draws.first
  Assert.equal 1, bingo.draws.last
  Assert.equal 3, bingo.boards.length
  Assert.equal 22, bingo.boards.first.numbers.first.first
  Assert.equal 19, bingo.boards.first.numbers.last.last
  Assert.equal 7, bingo.boards.last.numbers.last.last

  board, number = bingo.run
  Assert.equal 2, board.id
  Assert.equal 24, number
  Assert.equal 188, board.sum_unmarked

  bingo = Bingo.new(AoC::IO.input_file)
  board, number = bingo.run
  board.sum_unmarked * number
end

AoC.part 2 do
  board, number = Bingo.new(TEST_DATA).run(false)
  Assert.equal 1, board.id
  Assert.equal 13, number
  Assert.equal 148, board.sum_unmarked


  bingo = Bingo.new(AoC::IO.input_file)
  board, number = bingo.run(false)
  board.sum_unmarked * number
end
