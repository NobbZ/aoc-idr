module Aoc.Y2015.D01

import System.File
import Data.String

import Aoc.Data.Solutions

import Aoc.Y2015.D01.Input

data Paren = Open | Close

data AsParens : String -> Type where
  Nil : AsParens ""
  (::) : (p : Paren) -> {str : String} -> Lazy (AsParens str) -> AsParens (strCons c str)

asParens : (str : String) -> AsParens str
asParens str with (asList str)
  asParens ""                | []       = []
  asParens (strCons '(' str) | ('(' :: xs) = Open      :: asParens str
  asParens (strCons ')' str) | (')' :: xs) = Close     :: asParens str
  asParens (strCons _   str) | (_   :: xs) = believe_me $ asParens str

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
part1FromString n contents with (asParens contents)
  part1FromString n ""             | []          = n
  part1FromString n (strCons _ cs) | (Open  :: _) = part1FromString (inc n) cs
  part1FromString n (strCons _ cs) | (Close :: _) = part1FromString (dec n) cs

part1FromFile : IO Int
part1FromFile = pure $ part1FromString 0 input

export
part1 : Solution
part1 = (_ ** (part1FromFile, id, show))

part2FromString : Nat -> String -> Nat
part2FromString floor contents with (asParens contents)
  part2FromString floor      ""             | []           = 0
  part2FromString 0          (strCons _ cs) | (Close :: _) = 0
  part2FromString (S floor') (strCons _ cs) | (Close :: _) = S $ part2FromString    floor' cs
  part2FromString floor      (strCons _ cs) | (Open  :: _) = S $ part2FromString (S floor) cs

part2FromFile : IO Nat
part2FromFile = pure . S $ part2FromString 0 input

export
part2 : Solution
part2 = (_ ** (part2FromFile, cast, show))