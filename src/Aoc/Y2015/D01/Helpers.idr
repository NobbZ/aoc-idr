module Aoc.Y2015.D01.Helpers

import Data.String

public export
data Paren = Open | Close

public export
data AsParens : String -> Type where
  Nil : AsParens ""
  (::) : (p : Paren) -> {str : String} -> Lazy (AsParens str) -> AsParens (strCons c str)

export
asParens : (str : String) -> AsParens str
asParens str with (asList str)
  asParens ""                | []       = []
  asParens (strCons '(' str) | ('(' :: xs) = Open      :: asParens str
  asParens (strCons ')' str) | (')' :: xs) = Close     :: asParens str
  asParens (strCons _   str) | (_   :: xs) = believe_me $ asParens str

export
inc : Int -> Int
inc = (+) 1

export
dec : Int -> Int
dec n = n - 1