module EvalDivision where
    safeEval :: Expr -> Either String Int
safeEval expr =
  case expr of
    Lit num   -> Right num
    Add arg1 arg2 -> eval' (opHelper (+)) arg1 arg2
    Sub arg1 arg2 -> eval' (opHelper (-)) arg1 arg2
    Mul arg1 arg2 -> eval' (opHelper (*)) arg1 arg2
    Div arg1 arg2 -> eval' safeDiv arg1 arg2
    where
      safeDiv :: Int -> Int -> Either String Int
      safeDiv a b
        | b == 0 = Left "Error: division by zero"
        | otherwise = Right $ a `div` b

      opHelper ::
        (Int -> Int -> Int) ->
        Int ->
        Int ->
        Either String Int
      opHelper op a b = Right $ a `op` b

      eval' ::
        (Int -> Int -> Either String Int) ->
        Expr ->
        Expr ->
        Either String Int
      eval' operator arg1 arg2 =
        case safeEval arg1 of
          Left err -> Left err
          Right a ->
            case safeEval arg2 of
              Left err -> Left err
              Right b -> operator a b