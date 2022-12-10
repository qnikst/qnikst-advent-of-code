{-# LANGUAGE BlockArguments #-}
import Control.Monad
import Data.Foldable
main = do
    input <- lines <$> getContents
    let r = run input
    print $ sum $ take 6 $ map (\(i,x) -> i*x) $ filter (\(c,_) -> (c-20) `mod` 40 == 0) r
    draw $ init r
  where
    run = zip [1..] . go 1 0 id where
      go value 0 f [] = [f value]
      go value 0 f (cmd:cmds) = case cmd of
        "noop" -> (f value): go (f value) 0 id cmds
        'a':'d':'d':'x':' ':v -> (f value): go (f value) 1 (+ (read v)) cmds
      go value n f cmds = value: go value (n-1) f cmds
    draw [] = pure ()
    draw ((c,x):xs) = do
      let x' = (c-1) `mod` 40 + 1
      putStr $ if (x' >= x && x' <x+3) then "#" else "."
      when (c `mod` 40 == 0) $ putStrLn ""
      draw xs
       
        

