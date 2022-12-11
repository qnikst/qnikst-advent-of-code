{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE DeriveGeneric #-}
import Control.Lens
import Data.Generics.Labels
import qualified Data.Map as Map
import Data.Map (Map)
import Data.Generics.Product
import Data.List
import GHC.Generics
import GHC.Exts

data M = M
  { starting :: [Int]
  , operation :: Int -> Int
  , test :: Int -> Bool
  , action :: Bool -> Int
  }
  deriving (Generic)

{-
monkeys = 
  [  M { starting = [79, 98]
       , operation = \old -> old * 19
       , test = \x -> x `mod` 23 ==0
       , action = \case
          True -> 2
          False -> 3
       }
  , M { starting = [ 54, 65, 75, 74]
      , operation = \old -> old + 6
      , test = \x -> x `mod` 19 == 0
      , action = \case
         True -> 2
         False -> 0
      }
  , M { starting = [ 79, 60, 97]
      , operation = \old -> old * old
      , test = \x -> x `mod` 13 == 0
      , action = \case
         True -> 1
         False -> 3
      }
  , M { starting = [74]
      , operation = \old -> old + 3
      , test = \x -> x `mod` 17 == 0
      , action = \case
         True -> 0
         False -> 1
     }
  ]
-}
monkeys = 
 [ M { starting = [89, 84, 88, 78, 70]
     , operation = \old -> old * 5
     , test = \x -> x `mod` 7 == 0
     , action = \case
        True -> 6
        False -> 7
     }
 , M { starting = [76, 62, 61, 54, 69, 60, 85]
     , operation = \old -> old + 1
     , test = \x -> x `mod` 17 == 0
     , action = \case
        True -> 0
        False -> 6
     }
 , M { starting = [83, 89, 53]
     , operation = \old -> old + 8
     , test = \x -> x `mod` 11 == 0
     , action = \case
        True -> 5
        False -> 3
     }
 , M { starting = [95, 94, 85, 57]
     , operation = \old -> old + 4
     , test = \x -> x `mod` 13 == 0
     , action = \case
        True -> 0
        False -> 1
     }
 , M { starting = [82, 98]
     , operation = \old -> old + 7
     , test = \x -> x `mod` 19 == 0
     , action = \case
        True -> 5
        False -> 2 
     }
 , M { starting = [69]
     , operation = \old -> old + 2
     , test = \x -> x `mod` 2 == 0
     , action = \case
        True -> 1
        False -> 3
     }
 , M { starting = [82, 70, 58, 87, 59, 99, 92, 65]
     , operation = \old -> old * 11
     , test = \x -> x `mod` 5 == 0
     , action = \case
        True -> 7
        False -> 4
     }
 , M { starting = [ 91, 53, 96, 98, 68, 82 ] 
     , operation = \old -> old * old
     , test = \x -> x `mod` 3 == 0
     , action = \case
        True -> 4
        False -> 2
     }
  ]

modulus:: Int
modulus = product [ 7 , 17 , 11 , 13 , 19 , 2 , 5 , 3 ]

main = do
  let l = length monkeys
  -- print $ Map.elems $ fst $ (\x -> x & _2 . each %~ starting) $ last $ take (20*l) $ rounds monkeys
  print $ product $ take 2 $ sort $ fmap Down $ Map.elems $ fst $ (\x -> x & _2 . each %~ starting) $ last $ take (10000*l) $ rounds monkeys


rounds :: [M] -> [ (Map Int Integer, [M]) ]
rounds = go Map.empty 0 where
  go t time s = let (t',z) = inner t time s in (t', z) : go t' (time+1) z
  inner t time s = (Map.insertWith (+) i (genericLength $ starting m) t, foldl' process s (starting m)) where 
     m = s !! i
     i = time `mod` (length s)
     process z w = 
      let w' = operation m w `mod` modulus-- floor $ (fromIntegral $ operation m w) / 3 
          i' = action m $ (test m w')
      in z & ix i . #starting %~ drop 1
           & ix i' . #starting %~ (++[w'])

