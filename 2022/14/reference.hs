{-# LANGUAGE TupleSections #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BlockArguments #-}

import Data.Function
import Data.Functor
import qualified Data.Map.Strict as Map
import qualified Data.Text as T
import Data.Foldable

main = do
  input <- T.lines . T.pack <$> getContents
  let rocks
        = Map.fromList 
        $ input
       <&> T.splitOn "->"
       <&> fmap (T.splitOn ",")
       <&> fmap (\[l,h] -> (read (T.unpack l),read (T.unpack h)))
       >>= buildLine <&> (,'#')
  let bottom = maximum $ fmap snd $ Map.keys rocks
  let new_rocks = flip fix rocks \next s ->
                   case move bottom (500, 0) s of
                     Nothing -> []
                     Just c  ->
                       let s' = Map.insert c 'o' s
                       in s' : next s'
  print (length (new_rocks :: [Map.Map (Int,Int) Char]))
  let bottom2 = 2 + (maximum $ fmap snd $ Map.keys rocks)
  let new_rocks2 = flip fix rocks \next s ->
                   case move2 bottom2 (500, 0) s of
                     c | c == (500, 0) -> [s]
                       | otherwise ->
                          let s' = Map.insert c 'o' s
                          in s' : next s'
  print (length (new_rocks2 :: [Map.Map (Int,Int) Char]))

move :: Int -> (Int, Int) -> Map.Map (Int,Int) a -> Maybe (Int,Int)
move b (i, j) m 
  | j+1 > b = Nothing
  | Nothing <- Map.lookup (i,  j+1) m = move b (i,   j+1) m
  | Nothing <- Map.lookup (i-1,j+1) m = move b (i-1, j+1) m
  | Nothing <- Map.lookup (i+1,j+1) m = move b (i+1, j+1) m
  | otherwise                   = Just (i, j)

move2 :: Int -> (Int, Int) -> Map.Map (Int,Int) a -> (Int,Int)
move2 b (i, j) m 
  | j+1 >= b = (i, j)
  | Nothing <- Map.lookup (i,  j+1) m = move2 b (i,   j+1) m
  | Nothing <- Map.lookup (i-1,j+1) m = move2 b (i-1, j+1) m
  | Nothing <- Map.lookup (i+1,j+1) m = move2 b (i+1, j+1) m
  | otherwise                   = (i, j)

buildLine :: [(Int,Int)] -> [(Int, Int)]
buildLine [] = []
buildLine [x] = [x]
buildLine ((a,b):(i,j):xs)
    | a==i = ((a,) <$> [min b j..max b j]) <> buildLine ((i,j):xs)
    | b==j = ((,b) <$> [min a i..max a i]) <> buildLine ((i,j):xs)
    
   

