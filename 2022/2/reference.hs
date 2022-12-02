main = print .  foldl (\current input -> current + process input) 0
             .  lines
             =<< getContents
  where
   process (a:' ':b:_) =  score b + outcome a b
   score 'X' = 1
   score 'Y' = 2
   score 'Z' = 3
   -- rock
   outcome 'A' 'X' = 3
   outcome 'A' 'Y' = 6
   outcome 'A' 'Z' = 0
   -- paper
   outcome 'B' 'X' = 0
   outcome 'B' 'Y' = 3
   outcome 'B' 'Z' = 6
   -- scissors
   outcome 'C' 'X' = 6
   outcome 'C' 'Y' = 0
   outcome 'C' 'Z' = 3
     

