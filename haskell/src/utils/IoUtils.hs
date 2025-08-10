module Utils.IOUtils where

import System.IO (hFlush, stdout)
import Data.Char (isSpace)


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

-- | Função para limpar a tela
clearScreen :: IO ()
clearScreen = putStr "\ESC[2J"