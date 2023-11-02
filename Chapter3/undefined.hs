addThree :: Int -> Int -> Int -> Int
addThree a b c = op a (op b c)
  where
    op :: Int -> Int -> Int
    op = undefined