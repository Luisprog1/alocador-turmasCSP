module Repository.TestRepo where

import Tipos
import Text.Read (readMaybe)
import Data.Maybe (mapMaybe)
import System.IO (writeFile)
import Data.List (intercalate)
import Data.Char (toLower)


-- | Função para escrever todas as alocações em um arquivo. As alocações são geradas em tempo de execução. Elas podem ser lidas de um arquivo e alteradas ou adicionadas durante a execução do programa.
-- * allocs: lista de alocações a serem salvas
saveals :: [Allocation] -> IO ()
saveals allocs = do
    writeFile "src/data/teste.txt" (intercalate "\n" (map show allocs))

