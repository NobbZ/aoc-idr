module Aoc.Data.Solutions

import public Aoc.Data.LazyList

public export
Solutions : Type
Solutions = LazyList (Nat, Nat, Nat, (ty : Type ** (IO ty, ty -> Int, ty -> String)))

public export
Solution : Type
Solution = (ty : Type ** (IO ty, ty -> Int, ty -> String))