module Main where
  printSmallNumber num =
    let msg = if num < 10
        then show num
        else "the number is bigger than 10"
     in print msg 

  main = printSmallNumber 12