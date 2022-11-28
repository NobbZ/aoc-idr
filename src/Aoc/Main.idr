module Aoc.Main

import Data.Fin

import Aoc.Data.LazyList

import Aoc.Y2015 as Y15

Interpolation Int where
    interpolate = show

Interpolation Nat where
    interpolate = show

unwrap : (a, b, c, IO d) -> IO (a, b, c, d)
unwrap (a, b, c, d) = do
  d' <- d
  pure (a, b, c, d')

run : LazyList  (Nat, Nat, Nat, IO Int) -> IO ()
run []       = pure ()
run (x :: xs) = do
    (y, d, p, s) <- unwrap x
    putStrLn "\{y}-\{d}-\{p}: \{s}"
    run xs

main : IO ()
main = run Y15.list
