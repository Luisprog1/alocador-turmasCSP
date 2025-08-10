module View.UI where

import System.Console.ANSI

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