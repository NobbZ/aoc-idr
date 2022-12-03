module Aoc.Y2015.D01

import Aoc.Data.Solutions

import Aoc.Y2015.D01.Input
import Aoc.Y2015.D01.Part1 as P1
import Aoc.Y2015.D01.Part2 as P2

export
part1 : Solution
part1 = (_ ** (P1.run, id, show))

export
part2 : Solution
part2 = (_ ** (P2.run, cast, show))