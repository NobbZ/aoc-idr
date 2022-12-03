module Aoc.Y2015.D01.Part1

import Aoc.Y2015.D01.Input
import Aoc.Y2015.D01.Helpers

countBalance : Int -> String -> Int
countBalance n str with (asParens str)
  countBalance n ""             | []           = n
  countBalance n (strCons _ cs) | (Open  :: _) = countBalance (inc n) cs
  countBalance n (strCons _ cs) | (Close :: _) = countBalance (dec n) cs

export
run : IO Int
run = pure $ countBalance 0 input