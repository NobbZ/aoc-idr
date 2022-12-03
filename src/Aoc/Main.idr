module Aoc.Main

import Data.Fin
import Data.String
import System.Clock

import Aoc.Data.Solutions

import Aoc.Y2015 as Y15
import Aoc.Y2016 as Y16
import Aoc.Y2017 as Y17
import Aoc.Y2018 as Y18
import Aoc.Y2019 as Y19
import Aoc.Y2020 as Y20
import Aoc.Y2021 as Y21
import Aoc.Y2022 as Y22

Interpolation Int where
    interpolate = show

Interpolation Integer where
    interpolate = show

Interpolation Nat where
    interpolate = show

fractions : Integer -> (Integer, Integer, Integer)
fractions ns = (ns `div` 1000000, ns `div` 1000 `mod` 1000, ns `mod` 1000)

fractions' : Integer -> (Integer, Integer)
fractions' s = (s `div` 60, s `mod` 60)

Interpolation (Clock a) where
    interpolate (MkClock 0 ns') with (fractions ns')
        _ | (0,  0,  ns) = "\{ns}ns"
        _ | (0,  us, ns) = "\{us}µs \{ns}ns"
        _ | (ms, us, _)  = "\{ms}ms \{us}µs"
    interpolate c@(MkClock s' ns') with (fractions' s', fractions ns')
        _ | ((0, s), (ms, _, _)) = "\{s}.\{padLeft 3 '0' "\{ms}"}"
        _ | ((m, s), _)          = "\{m}:\{s}"

unwrap : (a, b, c, (ty : Type ** (IO ty, ty -> Int, ty -> String)))
   -> IO (a, b, c, (ty : Type ** (   ty, ty -> Int, ty -> String)))
unwrap (a, b, c, (typ ** (d, int, str))) = pure (a, b, c, (typ ** (!d, int, str)))

run : Solutions -> IO ()
run []       = pure ()
run (x :: xs) = do
    clock <- clockTime Process
    (y, d, p, (_ ** (sol, int, str))) <- unwrap x
    clock' <- clockTime Process
    let time = timeDifference clock' clock
    putStrLn "\{y}-\{padLeft 2 '0' $ interpolate d}-\{p}: \{int sol} (\{time})"
    run xs

main : IO ()
main = run (Y15.list ++ Y16.list ++ Y17.list ++ Y18.list ++ Y19.list ++ Y20.list ++ Y21.list ++ Y22.list)
