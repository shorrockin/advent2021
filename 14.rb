# typed: false
# frozen_string_literal: true
require './utils/boilerplate.rb'

Instructions = Struct.new(:template, :rules)

def process(instructions, steps)
  current = Hash.new(0)
  instructions.template.length.times do |index|
    key = instructions.template[index..index + 1]
    current[instructions.template[index]] += 1
    current[key] += 1 if key.length == 2
  end

  steps.times do
    changes = Hash.new(0)

    instructions.rules.each do |rule, result|
      current_counts = current[rule]
      next if current_counts == 0
      changes[result] += current_counts
      changes[result + rule[-1]] += current_counts
      changes[rule[0] + result] += current_counts
      changes[rule] -= current_counts
    end

    changes.each {|key, value| current[key] += value}
  end
  current
end

def calculate_solution(processed)
  counts = processed
    .select {|k, _| k.length == 1}
    .sort_by(&:last)
  counts.last.last - counts.first.last
end

def parse(input)
  input = input.split("\n") if input.is_a?(String)
  rules = input
    .select {|line| line.match?(/[A-Z]* -> [A-Z]/)}
    .map {|line| line.split(' -> ')}
    .to_h
  Instructions.new(input.first, rules)
end

TEST_INPUT = <<~TEST_INPUT
  NNCB

  CH -> B
  HH -> N
  CB -> H
  NH -> C
  HB -> C
  HC -> B
  HN -> C
  NN -> C
  BH -> H
  NC -> B
  NB -> B
  BN -> B
  BB -> N
  BC -> B
  CC -> N
  CN -> C
TEST_INPUT

AoC.part 1 do
  instructions = parse(TEST_INPUT)
  Assert.equal 16, instructions.rules.length
  Assert.equal 'NNCB', instructions.template
  Assert.equal 'B', instructions.rules['CH']
  Assert.equal 'C', instructions.rules['CN']
  Assert.equal 1588, calculate_solution(process(instructions, 10))
  calculate_solution(process(parse(AoC::IO.input_file), 10))
end

AoC.part 2 do
  calculate_solution(process(parse(AoC::IO.input_file), 40))
end
