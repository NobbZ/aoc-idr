module Aoc.Main

import Control.App
import Control.App.Console

import Aoc.Y2015.D01

data Counter : Type where

Interpolation Int where
    interpolate = show

-- hello : Console es => App es ()
-- hello = putStrLn "Hello, World!" 

hello : (Console es, State Counter Int es) => App es ()
hello = do c <- get Counter
           put Counter (c + 1)
           putStrLn "Hello, counting world"
           c <- get Counter
           putStrLn ("Counter \{c}")


-- main : HasIO io => IO ()
-- main = do n <- part1
--           putStrLn $ show n

main : IO ()
main = putStrLn . show $ f "()"