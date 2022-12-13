import Control.Applicative
import Control.Arrow
import Data.List
import Debug.Trace

data IL = I Int | IL [IL]
  deriving (Eq, Show)

instance Read IL where
  readsPrec i s = fmap (first I) (readsPrec i s) <|> fmap (first IL) (readsPrec i s)

instance Ord IL where
  compare (I a) (I b) = compare a b
  compare (I a) b@IL{} = compare (IL [I a]) b
  compare a@IL{} (I b) = compare a (IL [I b])
  compare (IL a) (IL b) = go a b where
    go [] [] = EQ
    go [] a  = LT
    go a  [] = GT
    go (a:as) (b:bs) = compare a b <> go as bs

main :: IO ()
main =  do
  input <- lines <$> getContents
  let pairs = map fst $ filter (\(_, [a,b]) -> compare (IL a) (IL b) /= GT) $ zip [1..] $ fmap (fmap (read)) $ sepBy "" input
  print $ sum (pairs :: [Int])
  let delim = [read "[[2]]" :: IL, read "[[6]]"]
  let sorted = fmap fst
             $ filter (\(_,x) -> x `elem` delim)
             $ zip [1..]
             $ sort 
             $ (delim++)
             $ fmap read
             $ filter (/="") input
  print (product sorted::Int)

sepBy :: Eq a => a -> [a] -> [[a]]
sepBy _ [] = []
sepBy p ls = let (pre, post) = break (==p) ls in pre: sepBy p (drop 1 post)
