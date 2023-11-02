swap :: (a,b) -> (b,a)
swap input =
  let
    newFirstElem = snd input
    newSecondElem = fst input
  in (newFirstElem, newSecondElem)