# typed: false
# frozen_string_literal: true
require './utils/boilerplate.rb'

Rule     = Struct.new(:open, :close, :p1_points, :p2_points)
NORMAL   = Rule.new('(', ')', 3, 1)
SQUARE   = Rule.new('[', ']', 57, 2)
CURLY    = Rule.new('{', '}', 1197, 3)
ANGLE    = Rule.new('<', '>', 25137, 4)
OPENINGS = [NORMAL, SQUARE, CURLY, ANGLE].map {|rule| [rule.open, rule]}.to_h
CLOSINGS = [NORMAL, SQUARE, CURLY, ANGLE].map {|rule| [rule.close, rule]}.to_h

def violation(line, return_type=:part_one)
  brackets = []
  line.chars.each do |char|
    if OPENINGS.keys.include?(char)
      brackets << OPENINGS[char]
    elsif brackets.last.close == char
      brackets.pop
    else
      return return_type == :part_one ? CLOSINGS[char] : nil
    end
  end
  return_type == :part_one ? nil : brackets.reverse
end

def calculate_violations(lines)
  lines
    .map {|l| violation(l)}
    .compact
    .map(&:p1_points)
    .sum
end

def calculate_incomplete(lines)
  scores = lines
    .map {|l| violation(l, :part_two)}
    .compact
    .map {|completions| completions.inject(0) {|i, c| (i * 5) + c.p2_points}}
    .sort
  scores[scores.length / 2]
end

TEST_INPUT = <<~TEST_INPUT
  [({(<(())[]>[[{[]{<()<>>
  [(()[<>])]({[<{<<[]>>(
  {([(<{}[<>[]}>{[]{[(<()>
  (((({<>}<{<{<>}{[]{[]{}
  [[<[([]))<([[{}[[()]]]
  [{[{({}]{}}([{[{{{}}([]
  {<[[]]>}<{[{[{[]{()[[[]
  [<(<(<(<{}))><([]([]()
  <{([([[(<>()){}]>(<<{{
  <{([{{}}[<[[[<>{}]]]>[]]
TEST_INPUT

AoC.part 1 do
  Assert.equal CURLY, violation('{([(<{}[<>[]}>{[]{[(<()>')
  Assert.equal NORMAL, violation('[[<[([]))<([[{}[[()]]]')
  Assert.equal SQUARE, violation('[{[{({}]{}}([{[{{{}}([]')
  Assert.equal NORMAL, violation('[<(<(<(<{}))><([]([]()')
  Assert.equal ANGLE, violation('<{([([[(<>()){}]>(<<{{')
  Assert.equal 26397, calculate_violations(TEST_INPUT.split("\n"))
  calculate_violations(AoC::IO.input_file)
end

AoC.part 2 do
  Assert.equal ['}', '}', ']', ']', ')', '}', ')', ']'], violation('[({(<(())[]>[[{[]{<()<>>', :part_two).map(&:close)
  Assert.equal 288957, calculate_incomplete(TEST_INPUT.split("\n"))
  calculate_incomplete(AoC::IO.input_file)
end
