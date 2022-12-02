main = print .  foldl (\current input -> current + process input) 0
             .  lines
             =<< getContents
  where
   process (a:' ':b:_) =  score b + outcome a b
   score 'X' = 0
   score 'Y' = 3
   score 'Z' = 6
   {- rock: 1, paper: 2, scissors: 3 -}
   -- rock
   outcome 'A' 'X' = 3
   outcome 'A' 'Y' = 1
   outcome 'A' 'Z' = 2
   -- paper
   outcome 'B' 'X' = 1
   outcome 'B' 'Y' = 2
   outcome 'B' 'Z' = 3
   -- scissors
   outcome 'C' 'X' = 2
   outcome 'C' 'Y' = 3
   outcome 'C' 'Z' = 1
     

