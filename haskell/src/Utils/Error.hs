-- src/Utils/Error.hs
module Utils.Error
  ( printError
  ) where

import System.Console.ANSI
  ( setSGR
  , SGR(..)
  , Color(..)
  , ColorIntensity(..)
  , ConsoleIntensity(..)
  , ConsoleLayer(..)
  )

-- | Mostra a mensagem de erro em vermelho/negrito, com prefixo [ERRO],
--   imprime linhas adicionais indentadas e pede Enter para continuar.
printError :: String -> IO ()
printError msg = do
  let ls = lines msg
      (firstLine, restLines) =
        case ls of
          []     -> ("", [])
          (x:xs) -> (x, xs)

  setSGR [SetConsoleIntensity BoldIntensity, SetColor Foreground Vivid Red]
  putStrLn ("[ERRO] " ++ firstLine)
  mapM_ (putStrLn . ("       " ++)) restLines
  setSGR [Reset]

  putStrLn "Pressione Enter para continuar..."
  _ <- getLine
  return ()
