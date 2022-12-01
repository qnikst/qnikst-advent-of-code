{-# Language TypeApplications #-}
import Data.List
main = print . sum .take 3 . reverse . sort . fmap (sum @_ @Int. fmap read) . splitOn "" . lines =<< getContents

splitOn p [] = []
splitOn p xs = takeWhile (/=p) xs: splitOn p (drop 1 $ dropWhile (/=p) xs)
