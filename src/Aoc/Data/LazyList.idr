module Aoc.Data.LazyList

public export
data LazyList a = Nil | (::) (Lazy a) (LazyList a)
    