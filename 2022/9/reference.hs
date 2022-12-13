{-# LANGUAGE BangPatterns #-}
import qualified Data.Set as Set
main = do
  input <- map ((\((x:_): c:_) -> (x, read c)) . words) . lines <$> getContents
  -- print (input :: [(Char, Int)])
  let go !s h t [] = Set.size s
      go !s h t ((_, 0):ds) = go s h t ds
      go !s h t ((dir, c):ds) =
         let h' = move dir h
             t' = follow h' t
         in go (Set.insert t' s) h' t' ((dir, c-1):ds)
  print $ go Set.empty (0,0) (0,0) input

move 'R' (hx, hy) = (hx+1, hy)
move 'U' (hx, hy) = (hx, hy+1)
move 'L' (hx, hy) = (hx-1, hy)
move 'D' (hx, hy) = (hx, hy-1)
move _ h = h

{-
   -2 -1  0  1  2
  2 .  H  H  H  .
  1 H  .  .  .  H
  0 H  .  T  .  H
 -1 H  .  .  .  H
 -2 .  H  H  H  .
-}


follow (hx, hy) (tx, ty) = case (hx-tx, hy-ty) of
   (-1, 2) -> (tx-1, ty+1)
   ( 0, 2) -> (tx  , ty+1)
   ( 1, 2) -> (tx+1, ty+1)
   (-2, 1) -> (tx-1, ty+1)
   ( 2, 1) -> (tx+1, ty+1)
   (-2, 0) -> (tx-1, ty  )
   ( 2, 0) -> (tx+1, ty  )
   (-2,-1) -> (tx-1, ty-1)
   ( 2,-1) -> (tx+1, ty-1)
   (-1,-2) -> (tx-1, ty-1)
   ( 0,-2) -> (tx  , ty-1)
   ( 1,-2) -> (tx+1, ty-1)
   _ -> (tx, ty)
  
