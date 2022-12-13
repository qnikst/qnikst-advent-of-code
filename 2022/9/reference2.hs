{-# LANGUAGE BangPatterns #-}
import qualified Data.Set as Set
main = do
  input <- map ((\((x:_): c:_) -> (x, read c)) . words) . lines <$> getContents
  print (input :: [(Char, Int)])
  let go !s h ts [] = Set.size s
      go !s h ts ((_, 0):ds) = go s h ts ds
      go !s h ts ((dir, c):ds) =
         let h' = move dir h
             ts' = follows h' ts
         in go (Set.insert (last ts') s) h' ts' ((dir, c-1):ds)
  print $ go Set.empty (0,0) (replicate 9 (0,0)) input

follows h [] = []
follows h (t:ts) =
  let t' = follow h t
  in t':follows t' ts

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
   (-2, 2) -> (tx-1, ty+1)
   (-1, 2) -> (tx-1, ty+1)
   ( 0, 2) -> (tx  , ty+1)
   ( 1, 2) -> (tx+1, ty+1)
   ( 2, 2) -> (tx+1, ty+1)
   (-2, 1) -> (tx-1, ty+1)
   ( 2, 1) -> (tx+1, ty+1)
   (-2, 0) -> (tx-1, ty  )
   ( 2, 0) -> (tx+1, ty  )
   (-2,-1) -> (tx-1, ty-1)
   ( 2,-1) -> (tx+1, ty-1)
   (-2,-2) -> (tx-1, ty-1)
   (-1,-2) -> (tx-1, ty-1)
   ( 0,-2) -> (tx  , ty-1)
   ( 1,-2) -> (tx+1, ty-1)
   ( 2,-2) -> (tx+1, ty-1)
   _ -> (tx, ty)
  
