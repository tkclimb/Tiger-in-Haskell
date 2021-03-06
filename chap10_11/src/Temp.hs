module Temp where

import qualified Symbol

type Label = Symbol.Symbol
data Temp = Temp { temps :: Int, labs :: Int, num :: Int}
            deriving Show

create :: Temp
create = Temp {temps=1, labs=0, num=0}

newTemp :: Temp -> (Int, Temp)
newTemp t@Temp{temps=n}  = (n, t{temps = n + 1})

makeString :: Int -> String
makeString n | n >= 0 = "t" ++ show n
             | n >= -5 = "v" ++ show (-n-1)
             | otherwise = "p" ++ show (-n-6)

newLabel :: Temp -> (Label, Temp)
newLabel t@Temp{labs=n} = 
  let
    label = Symbol.fromString $ "L" ++ show n
    labs' = n + 1
  in
   (label, t{labs=labs'})

namedLabel :: String -> Label
namedLabel = Symbol.fromString

newNum :: Temp -> (Int, Temp)
newNum t@Temp{num=n} = (n, t{num = n+1})
