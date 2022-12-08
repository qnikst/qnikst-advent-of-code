import Data.Char

main = do
  input <- map (map digitToInt) . lines <$> getContents
  let result =
        [ (i,j, scores)
        | (i, line)    <- zip [0..] input
        , (j, current) <- zip [0..] line
        , (left, _:right) <- pure $ splitAt j line
        , let column = [ l !! j | l <- input]
        , (top, _:bottom) <- pure $ splitAt i column
        , or
           [ all (<current) left
           , all (<current) right
           , all (<current) top
           , all (<current) bottom
           ]
        , let scores = product
                [ min (length x) $ succ $ length $ takeWhile (<current) x
                | x <- [reverse left, right, reverse top, bottom]
                ]
        ]
  print $ maximum $ map (\(_,_,s) -> s) result
  
