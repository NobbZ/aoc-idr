module Aoc.Data.LazyList

public export
data LazyList a = Nil | (::) (Lazy a) (LazyList a)

export
(++) : LazyList a -> LazyList a -> LazyList a
[]        ++ ys = ys
(x :: xs) ++ ys = x :: (xs ++ ys)
