module Aoc.Y2015.D01.Part2

import Aoc.Y2015.D01.Input
import Aoc.Y2015.D01.Helpers

countFloors : Nat -> String -> Nat
countFloors floor str with (asParens str)
  countFloors    floor  ""             | []           = 0
  countFloors 0         (strCons _ cs) | (Close :: _) = 0
  countFloors (S floor) (strCons _ cs) | (Close :: _) = S $ countFloors    floor  cs
  countFloors    floor  (strCons _ cs) | (Open  :: _) = S $ countFloors (S floor) cs

export
run : IO Nat
run = pure $ countFloors 0 input