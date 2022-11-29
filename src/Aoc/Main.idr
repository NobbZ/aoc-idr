module Aoc.Main

import Data.Fin
import System.Clock

import Aoc.Data.LazyList

import Aoc.Y2015 as Y15

Interpolation Int where
    interpolate = show

Interpolation Integer where
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
    clock <- clockTime Process
    let t = seconds clock * 1000000000 + nanoseconds clock
    (y, d, p, s) <- unwrap x
    clock <- clockTime Process
    let t' = seconds clock * 1000000000 + nanoseconds clock
    let time = t' - t
    let (ms', us) = (time `div` 1000000, time `div` 1000 `mod` 1000)
    let (sec', ms) = (ms' `div` 1000, time `mod` 1000)
    putStrLn "\{y}-\{d}-\{p}: \{s} \{sec'}.\{ms}_\{us} seconds"
    run xs

main : IO ()
main = run Y15.list
