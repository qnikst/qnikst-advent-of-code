
import qualified Data.Set as Set
              

main = do
  input <- lines <$> getContents
  let moves (x,y)
       = filter (\(i,_) -> i>=0 && i < length (head input))
       $ filter (\(_,j) -> j>=0 && j<length input)
       $ [ (x-1,y), (x+1,y), (x,y-1), (x,y+1) ]
  let allowed c' (i,j) = 
        let c = normalize c'
            n = normalize $ input !! j !! i
        in (succ c) >= n 
  let inputs = (head [ (i,j) | (j, line) <- zip [0..] input, (i, 'S') <- zip [0..] line])
             : [ (i,j) | (j, line) <- zip [0..] input, (i, 'a') <- zip [0..] line]
  print $ minimum $ filter (either (const False) (const True)) $ map (last . run input moves allowed) $ zip inputs (repeat 0)

normalize c
  | c == 'S' = 'a'
  | c == 'E' = 'z'
  | otherwise = c

run input moves allowed f = go Set.empty [f] where
  go _ [] = []
  go s' (f:fs) = case f of
    ((i,j),l) -> case input !! j !! i of
        'E' -> [Right l]
        c   -> 
            let s = Set.insert (i,j) s'
                next = filter ((`Set.notMember` s) . fst) $ fs ++ [ (z,l+1)  | z <- filter (allowed c) $ moves (i,j)]
            in Left (s,next) : go s next
