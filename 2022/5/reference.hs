import Data.Char
import Data.List
main = do
  input_lines <- lines <$> getContents
  let (stacks_lines, _:rules) = break (=="") input_lines
  let stacks_count = (length (head stacks_lines)+1) `div` 4
  let stacks =
         [ dropWhile (==' ') [ l !! (1 + (i-1)*4)
           | l <- init stacks_lines
           ]
         | i <- [1..stacks_count]
         ]
  let actions = map (map read . words . filter ((||) <$> isDigit <*> (==' '))) rules
  let r = foldl' (\s [count, from, to] -> 
            foldl' (\z () ->
              let x = head (z !! (from-1))
              in update (tail) (from-1)
                  $ update (x:) (to-1) z
              ) s (replicate count ())
           ) stacks actions
  print r

update _ _ [] = []
update f 0 (s:ss)    = f s : ss
update f (n) (s:ss)  = s : update f (n-1) ss
