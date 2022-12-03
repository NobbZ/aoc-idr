module Aoc.Y2015.D01

import System.File
import Data.String

import Aoc.Data.Solutions

-- TODO: Create a "view" that shows the string as `List Paren`

interface Default a where
  default' : a

Default Nat where
  default' = 0

Default Int where
  default' = 0

callWithInput : (Default a) => (String -> a) -> String -> IO a
callWithInput f file = do
  fileOrErr <- readFile file
  case fileOrErr of
    Right str => pure $ f str
    Left err => do
      putStrLn $ show err
      pure default'

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
part1 : Solution
part1 = (_ ** (part1FromFile path, id, show))

part2FromString : Nat -> String -> Nat
part2FromString floor contents with (asList contents)
  part2FromString floor      ""             | []         = 0
  part2FromString 0          (strCons _ cs) | (')' :: _) = 0
  part2FromString (S floor') (strCons _ cs) | (')' :: _) = S $ part2FromString floor' cs
  part2FromString floor      (strCons _ cs) | ('(' :: _) = S $ part2FromString (S floor) cs
  part2FromString floor      (strCons _ cs) | (_   :: _) =     part2FromString floor cs

part2FromFile : String -> IO Nat
part2FromFile = callWithInput $ S . part2FromString 0

export
part2 : Solution
part2 = (_ ** (part2FromFile path, cast, show))