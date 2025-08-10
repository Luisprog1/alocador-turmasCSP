module View.UI where

import System.Console.ANSI
import System.IO (hFlush, stdout)
import Data.Char (isSpace)

logo :: String
logo =
    "   █████╗ ██╗      ██████╗  ██████╗  █████╗ ██████╗  ██████╗  ██████╗  \n" ++
    "  ██╔══██╗██║     ██╔═══██╗██╔════╝ ██╔══██╗██╔══██╗██╔═══██╗ ██╔══██╗ \n" ++
    "  ███████║██║     ██║   ██║██║      ███████║██   ██║██║   ██║ ██████╔╝ \n" ++
    "  ██╔══██║██║     ██║   ██║██║      ██╔══██║██   ██║██║   ██║ ██╔══██╗ \n" ++
    "  ██║  ██║███████╗╚██████╔╝╚██████╔ ██║  ██║███████╝╚██████╔╝ ██║  ██║ \n" ++
    "  ╚═╝  ╚═╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═════╝  ╚═════╝  ╚═╝  ╚═╝ "

-- | Função para desenhar cabeçalho com logo e título
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

drawSubHeader :: String -> IO ()
drawSubHeader subtitle = do
    setSGR [SetColor Foreground Dull Blue]
    putStrLn (subtitle ++ " ---")
    setSGR [Reset]

-- | Função para ler uma linha da entrada padrão
readLine :: String -> IO String
readLine prompt = do
    putStr prompt
    hFlush stdout
    line <- getLine
    let trimmed = dropWhile isSpace (reverse (dropWhile isSpace (reverse line)))
    if null trimmed
        then do
            putStrLn "Entrada vazia, por favor tente novamente."
            readLine prompt
        else
            return trimmed