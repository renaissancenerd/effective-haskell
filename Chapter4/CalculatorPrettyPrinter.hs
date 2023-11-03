{-# LANGUAGE DerivingStrategies #-}

module CalculatorPrettyPrinter where

import Text.Read (readEither)

data Expr
  = Lit Int
  | Sub Expr Expr
  | Add Expr Expr
  | Mul Expr Expr
  | Div Expr Expr
  deriving stock (Eq, Show)

eval :: Expr -> Int
eval expr =
  case expr of
    Lit num   -> num
    Add arg1 arg2 -> eval' (+) arg1 arg2
    Sub arg1 arg2 -> eval' (-) arg1 arg2
    Mul arg1 arg2 -> eval' (*) arg1 arg2
    Div arg1 arg2 -> eval' div arg1 arg2
    where
      eval' :: (Int -> Int -> Int) -> Expr -> Expr -> Int
      eval' operator arg1 arg2 =
        operator (eval arg1) (eval arg2)

parse :: String -> Either String Expr
parse str =
  case parse' (words str) of
    Left err       -> Left err
    Right (e,[])   -> Right e
    Right (_,rest) -> Left $ "Found extra tokens: " <> unwords rest

parse' :: [String] -> Either String (Expr,[String])
parse' []  = Left "unexpected end of expression"
parse' (token:rest) =
  case token of
    "+" -> parseBinary Add rest
    "*" -> parseBinary Mul rest
    "-" -> parseBinary Sub rest
    "/" -> parseBinary Div rest
    lit ->
      case readEither lit of
        Left err -> Left err
        Right lit' -> Right (Lit lit', rest)

parseBinary ::
  (Expr -> Expr -> Expr)
  -> [String]
  -> Either String (Expr, [String])
parseBinary exprConstructor args =
  case parse' args of
    Left err -> Left err
    Right (firstArg,rest') ->
      case parse' rest' of
        Left err -> Left err
        Right (secondArg,rest'') ->
          Right $ (exprConstructor firstArg secondArg, rest'')

run :: String -> String
run expr =
  case parse expr of
    Left err -> "Error: " <> err
    Right expr' ->
      let answer = show $ eval expr'
      in "The answer is: " <> answer

prettyPrint :: Expr -> String
prettyPrint expr =
  prettyPrint' expr <> " = " <> show result
  where
    result = eval expr
    prettyPrint' = prettyPrintWrapped id
    prettyWithParens = prettyPrintWrapped $ \pretty -> "(" <> pretty <> ")"
    prettyPrintWrapped wrapper e =
      case e of
        Lit n -> show n
        Sub a b -> wrapper $ prettyOperation " - " a b
        Add a b -> wrapper $ prettyOperation " + " a b
        Mul a b -> wrapper $ prettyOperation " × " a b
        Div a b -> wrapper $ prettyOperation " ÷ " a b
    prettyOperation op a b =
      prettyWithParens a <> op <>  prettyWithParens b

prettyPrintNoExtraParens :: Expr -> String
prettyPrintNoExtraParens expr =
  prettyPrint' expr <> " = " <> show result
  where
    result = eval expr
    prettyPrint' e =
      case e of
        Lit n -> show n
        Sub a b -> prettyOperation " - " a b
        Add a b -> prettyOperation " + " a b
        Mul a b -> prettyOperation " × " a b
        Div a b -> prettyOperation " ÷ " a b

    prettyWithParens e =
      case e of
        Lit n -> show n
        Sub a b -> "(" <> prettyOperation " - " a b <> ")"
        Add a b -> "(" <> prettyOperation " + " a b <> ")"
        Mul a b -> "(" <> prettyOperation " × " a b <> ")"
        Div a b -> "(" <> prettyOperation " ÷ " a b <> ")"

    prettyOperation op a b =
      prettyWithParens a <> op <>  prettyWithParens b

prettyPrintSimple :: Expr -> String
prettyPrintSimple expr =
  prettyPrint' expr <> " = " <> show result
  where
    result = eval expr
    prettyPrint' e =
      case e of
        Lit n -> show n
        Sub a b -> prettyOperation " - " a b
        Add a b -> prettyOperation " + " a b
        Mul a b -> prettyOperation " × " a b
        Div a b -> prettyOperation " ÷ " a b

    prettyOperation op a b =
      "(" <> prettyPrint' a <> op <> prettyPrint' b <> ")"

prettyPrintNoParens :: Expr -> String
prettyPrintNoParens expr =
  prettyPrint' expr <> " = " <> show result
  where
    result = eval expr
    prettyPrint' e =
      case e of
        Lit n -> show n
        Sub a b -> prettyOperation " - " a b
        Add a b -> prettyOperation " + " a b
        Mul a b -> prettyOperation " × " a b
        Div a b -> prettyOperation " ÷ " a b

    prettyOperation :: String -> Expr -> Expr -> String
    prettyOperation op a b =
      prettyPrint' a <> op <> prettyPrint' b