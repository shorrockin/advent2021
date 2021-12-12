# typed: false
# frozen_string_literal: true
require './utils/boilerplate.rb'

Node = Struct.new(:label, :repeatable)
Graph = Struct.new(:nodes, :start, :end)

def parse(lines)
  lines = lines.split("\n") if lines.is_a?(String)

  nodes = lines.each_with_object({}) do |line, result|
    origin_label, destination_label = line.split("-")
    origin = Node.new(origin_label, origin_label.upcase == origin_label)
    destination = Node.new(destination_label, destination_label.upcase == destination_label)
    result[origin] = (result[origin] || []) << destination
    result[destination] = (result[destination] || []) << origin
  end
  Graph.new(nodes, nodes.keys.find {|n| n.label == 'start'}, nodes.keys.find {|n| n.label == 'end'})
end

def paths(graph, visit_verifyer, current=graph.start, current_path=[graph.start])
  graph.nodes[current].map do |edge|
    next [current_path + [edge]] if edge == graph.end
    next nil if edge == graph.start
    next nil unless visit_verifyer.call(current_path, edge)

    paths(graph, visit_verifyer, edge, current_path + [edge])
      .compact
      .select {|path| path.last == graph.end}
  end.flatten(1)
end

TEST_INPUT = <<~TEST_INPUT
  start-A
  start-b
  A-c
  A-b
  b-d
  A-end
  b-end
TEST_INPUT

AoC.part 1 do
  visit_verifyer = lambda do |current_path, edge|
    edge.repeatable || !current_path.include?(edge)
  end

  Assert.equal 10, paths(parse(TEST_INPUT), visit_verifyer).length
  paths(parse(AoC::IO.input_file), visit_verifyer).length
end

AoC.part 2 do
  visit_verifyer = lambda do |current_path, edge|
    double_visited_any = current_path.group_by(&:itself).any? {|k, v| !k.repeatable && v.length > 1}
    times_visited = current_path.count {|p| p == edge}
    return true if times_visited == 0
    return true if times_visited == 1 && !double_visited_any
    edge.repeatable
  end

  Assert.equal 36, paths(parse(TEST_INPUT), visit_verifyer).length
  paths(parse(AoC::IO.input_file), visit_verifyer).length
end
