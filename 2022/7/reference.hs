import Data.List
import qualified Data.Map as M

main = do
  input <- lines <$> getContents
  let s = process input ["/"] M.empty
  let total_current = s M.! []
  print $ sum $ M.elems $ M.filter (<= 100000) s
  print $ head $ sort $ M.elems $ M.filter (\s -> 70000000 - total_current + s > 30000000) s

type Path = [String]

process :: [String] -> Path -> M.Map Path Int -> M.Map Path Int
process [] _ x = x
process (c:cs) p@(_:ps) x = case c of
  "$ cd .." -> process cs ps x
  ('$':' ':'c':'d':' ':cwd) -> process cs (cwd:p) x
  "$ ls" -> 
    let (dirs,cmds) = break (\s -> head s == '$') cs 
        size = sum $ map read $ filter (/="dir") $ map (head .words) dirs 
        x' = foldl' (\z path -> M.insertWith (+) path size z) x (tails p)
    in process cmds p x'
  
