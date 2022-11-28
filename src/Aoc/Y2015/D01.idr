module Aoc.Y2015.D01

import System.File
import Data.String

export
f : String -> Nat
f s with (asList s)
  f "" | [] = ?fh_0
  f (strCons _ _) | (c :: x) = ?fh_1

-- part1FromString : String -> Nat
-- part1FromString contents with (asList contents)
--   _ | [] = ?foo_0
--   _ | (c :: x) = ?foo_1

-- part1FromFile : HasIO io => String -> io Nat
-- part1FromFile file = do contents <- readFile file
--                         case contents of
--                             Left error => do putStrLn $ show error
--                                              pure 0
--                             Right x => pure $ part1FromString x


-- export
-- part1 : HasIO io => io Nat
-- part1 = part1FromFile "data/2015/01.txt"

