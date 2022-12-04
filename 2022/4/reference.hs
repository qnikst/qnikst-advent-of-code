{-# LANGUAGE ScopedTypeVariables #-}
main = print . sum. map process . lines =<< getContents where
  -- process line = fromEnum $ (a1<=a2 && b2 <= b1) || (a1>=a2 && b2 >= b1) where
  --
  --              a1     b1
  --              a2    b2 
  --   
  process line = fromEnum $ (a2<=b1) && (a1<=b2) where
    (pre, _:post) = break (==',') line
    (a1::Int,b1::Int) = split pre
    (a2,b2) = split post
    split input = (read a, read b) where
      (a,_:b) = break (=='-') input
 
    
