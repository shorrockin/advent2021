# typed: false
# frozen_string_literal: true
require './utils/boilerplate.rb'

AoC.part 1 do
  AoC::IO.input_file.sum do |l|
    l.split(' | ')[1].split(' ').select {|p| [2, 4, 3, 7].include?(p.length)}.length
  end
end

def contains_chars?(target, test)
  test.chars.all? {|c| target.include?(c)}
end

AoC.part 2 do
  AoC::IO.input_file.sum do |line|
    input, output = line.split(' | ')
    values = input.split(' ').map {|v| v.chars.sort.join}

    # solves for the known lengths
    lookup = {
      1 => values.find {|v| v.length == 2},
      7 => values.find {|v| v.length == 3},
      4 => values.find {|v| v.length == 4},
      8 => values.find {|v| v.length == 7},
    }

    # solves for the length 6
    lookup[9] = values.find {|v| v.length == 6 && contains_chars?(v, lookup[4])}
    lookup[0] = values.find {|v| v.length == 6 && v != lookup[9] && contains_chars?(v, lookup[1])}
    lookup[6] = values.find {|v| v.length == 6 && v != lookup[9] && v != lookup[0]}

    # solves for length 5
    lookup[3] = values.find {|v| v.length == 5 && contains_chars?(v, lookup[1])}
    lookup[5] = values.find {|v| v.length == 5 && contains_chars?(v, (lookup[4].chars - lookup[1].chars).join)}
    lookup[2] = values.find {|v| v.length == 5 && v != lookup[3] && v != lookup[5]}

    # reverse the hash to lookup by alpha
    lookup = lookup.map {|k, v| [v, k]}.to_h
    output.split(' ').map {|k| lookup[k.chars.sort.join]}.join.to_i
  end
end
