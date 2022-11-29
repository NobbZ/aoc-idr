module Aoc.Y2015.D01

import System.File
import Data.String

-- TODO: Create a "view" that shows the string as `List Paren`

callWithInput : (String -> Int) -> String -> IO Int
callWithInput f file = do
  fileOrErr <- readFile file
  case fileOrErr of
    Right str => pure $ f str
    Left err => do
      putStrLn $ show err
      pure 0

inc : Int -> Int
inc = (+) 1

dec : Int -> Int
dec n = n - 1

path : String
path = "data/2015/01.txt"

part1FromString : Int -> String -> Int
part1FromString n contents with (asList contents)
  part1FromString n ""             | []         = n
  part1FromString n (strCons _ cs) | ('(' :: _) = part1FromString (inc n) cs
  part1FromString n (strCons _ cs) | (')' :: _) = part1FromString (dec n) cs
  part1FromString n (strCons _ cs) | (_   :: _) = part1FromString n       cs

part1FromFile : String -> IO Int
part1FromFile file = callWithInput (part1FromString 0) file

export
part1 : IO Int
part1 = part1FromFile path

part2FromString : Nat -> String -> Nat
part2FromString floor contents with (asList contents)
  part2FromString floor      ""             | []         = 0
  part2FromString 0          (strCons _ cs) | (')' :: _) = 0
  part2FromString (S floor') (strCons _ cs) | (')' :: _) = S $ part2FromString floor' cs
  part2FromString floor      (strCons _ cs) | ('(' :: _) = S $ part2FromString (S floor) cs
  part2FromString floor      (strCons _ cs) | (_   :: _) = part2FromString floor cs

part2FromFile : String -> IO Int
part2FromFile file = callWithInput (cast . S . part2FromString 0) file

export
part2 : IO Int
part2 = part2FromFile path