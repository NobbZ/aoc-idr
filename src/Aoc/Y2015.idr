module Aoc.Y2015

import Data.Fin

import Aoc.Data.Solutions

import Aoc.Y2015.D01 as D01

export
list : Solutions
list = [
    (2015, 1, 1, D01.part1),
    (2015, 1, 2, D01.part2)]
