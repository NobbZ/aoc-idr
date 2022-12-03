module Aoc.Data.LazyList

public export
LazyList : Type -> Type
LazyList a = List (Lazy a)
