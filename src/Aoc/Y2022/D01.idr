module Aoc.Y2022.D01

import Data.String
import Data.List
import Data.List1
import Data.Vect
import System.File

import Aoc.Data.Solutions

interface Default a where
  default' : a

Default Nat where
  default' = 0

path : String
path = "data/2022/01.txt"

callWithInput : (Default a) => (String -> a) -> String -> IO a
callWithInput f file = do
  fileOrErr <- readFile file
  case fileOrErr of
    Right str => pure $ f str
    Left err => do
      putStrLn $ show err
      pure default'

sort1 : (Ord a) => List1 a -> List1 a
sort1 (x ::: xs) = case sort (x :: xs) of
  (y :: ys) => y ::: ys
  [] => x ::: xs -- unreachable, I hope, though this makes it work for now!

 
part1FromString : String -> Nat
part1FromString contents = head . reverse . sort1 . map sum . map (map stringToNatOrZ) . splitOn "" . lines $ contents

part1FromFile : String -> IO Nat
part1FromFile = callWithInput part1FromString

-- part2FromString : String -> Nat
-- part2FromString contents = case reverse . sort1 . map sum . map (map stringToNatOrZ) . splitOn "" . lines $ contents of
--   (x :: y :: z :: _) => x+y+z
--   _ => 0 -- should be unreachable




export
part2 : Solution
part2 = ?p2

part1exampleInputs : String
part1exampleInputs = """
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
"""

export
part1 : Solution
part1 = (Nat ** ((part1FromFile path), cast, show))
