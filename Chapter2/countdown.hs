module Countdown where
    countdown n =
        if n <= 0 then []
        else n : countdown (n - 1)
