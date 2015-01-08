module Main where

import Test.Hspec

import qualified Data.Map as Map

import qualified Assem as A
import qualified Codegen as CG
import qualified DalvikFrame as Frame
import qualified Graph as G
import qualified Temp
import qualified Flow

import MakeGraph
import Liveness
import Color

live_test :: IO ()
live_test =
  let
    na = A.constInstr 1 [0, 1]                   -- a. t0 := 1
    nb = A.constInstr 2 [2, 3]                   -- b. t2 := 2
    n1 = A.constInstr 0 [4, 5]                   -- 1. a(t4) := 0
    l0 = A.labelDef "L0"
    n2 = A.addInstr [6, 7, 8] [4, 0]             -- 2. b(t6) := 1 + 1
    n3 = A.addInstr [9, 10, 11] [9, 6]           -- 3. c(t9) := c + b
    n4 = A.mulInstr [4, 12, 13] [6, 2]           -- 4. a := b * 2
    n5 = A.cjumpInstr "gt" [14, 15] [4, 16] "L0" -- 5. a < N (t16)
    n6 = A.returnInstr 9

    is = [na, nb, n1, l0, n2, n3, n4, n5, n6]
    (cflow, nodes) = instrs2graph is
    g = Flow.get_control cflow
    ds = Flow.get_def cflow
    us = Flow.get_use cflow
    ismove = Flow.get_ismove cflow
    outs = calcLiveness ds us g

    adjListMap = build nodes ds us ismove outs
    selectStack = Map.keys adjListMap
    colmap = assignColor adjListMap selectStack
  in
   do
     print outs
     print adjListMap
     print colmap


main ::IO ()
main = do
  live_test
