module View.UI where

import System.Console.ANSI
import System.IO (hFlush, stdout)
import Data.Char (isSpace)
import Data.List (dropWhileEnd)

logo :: String
logo =
    "   █████╗ ██╗      ██████╗  ██████╗  █████╗ ██████╗  ██████╗  ██████╗  \n" ++
    "  ██╔══██╗██║     ██╔═══██╗██╔════╝ ██╔══██╗██╔══██╗██╔═══██╗ ██╔══██╗ \n" ++
    "  ███████║██║     ██║   ██║██║      ███████║██   ██║██║   ██║ ██████╔╝ \n" ++
    "  ██╔══██║██║     ██║   ██║██║      ██╔══██║██   ██║██║   ██║ ██╔══██╗ \n" ++
    "  ██║  ██║███████╗╚██████╔╝╚██████╔ ██║  ██║███████╝╚██████╔╝ ██║  ██║ \n" ++
    "  ╚═╝  ╚═╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═════╝  ╚═════╝  ╚═╝  ╚═╝ "

-- | Função para desenhar cabeçalho com logo e título
-- * title: título da tela
drawHeader :: String -> IO ()
drawHeader title = do
    clearScreen
    setCursorPosition 0 0
    -- | Logo em amarelo
    setSGR [SetColor Foreground Vivid Yellow]
    putStrLn logo
    setSGR [Reset]
    putStrLn ""
    -- | Título da tela em ciano
    setSGR [SetColor Foreground Vivid Cyan]
    putStrLn ("===============  " ++ title ++ "  ===============")
    setSGR [Reset]
    putStrLn ""

-- | Função para desenhar um subtítulo
-- * subtitle: subtítulo da seção
drawSubHeader :: String -> IO ()
drawSubHeader subtitle = do
    setSGR [SetColor Foreground Dull Blue]
    putStrLn (subtitle ++ " ---")
    setSGR [Reset]

-- | Trim simples (sem precisar de reverse duas vezes)
trim :: String -> String
trim = dropWhile isSpace . dropWhileEnd isSpace

-- | Quando a entrada é OBRIGATÓRIA (não aceita vazio)
readLine :: String -> IO String
readLine prompt = do
  putStr prompt
  hFlush stdout
  line <- getLine
  let t = trim line
  if null t
     then do
       putStrLn "Entrada vazia, por favor tente novamente."
       readLine prompt
     else
       return t

-- | Quando a entrada PODE ser vazia (Enter para cancelar/voltar)
readLineMaybe :: String -> IO String
readLineMaybe prompt = do
  putStr prompt
  hFlush stdout
  line <- getLine
  return (trim line)