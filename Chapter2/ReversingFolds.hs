module ReversingFolds where
    {- Reversing a list using a foldl can be done by prepending each new element to the front of the new list. 
    Since foldl is left-associative, we’ll start with the first element of our old list. 
    Adding each new element to the beginning of the reversed list means we’ll finish by adding the final element of the original list to the beginning of the new list -}
    reverseLeft = foldl insertElem []
      where insertElem reversed a = a : reversed

    {- This is less efficient because we have to walk through the entire reversed list for every item we add, so that we can insert new items at the end. -}

    reverseRight = foldr insertElem []
      where insertElem a reversed = reversed <> [a]
