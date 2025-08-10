module Repository.AlocateRepository where

import Tipos
import Text.Read (readMaybe)
import Data.Maybe (mapMaybe)
import System.IO (writeFile)
import Data.List (intercalate)
import Data.Char (toLower)
import Utils.Alocate


-- | Função para escrever todas as alocações em um arquivo. As alocações são geradas em tempo de execução. Elas podem ser lidas de um arquivo e alteradas ou adicionadas durante a execução do programa.
-- * allocs: lista de alocações a serem salvas
saveAllocs :: [Allocation] -> IO ()
saveAllocs allocs = do
    writeFile "src/data/allocate.txt" (intercalate "\n" (map show allocs))

-- | Lê as alocações de um arquivo. Converte as alocações do arquivo para que as alocações possam ser manipuladas durante a execução do programa.
getAllocs :: IO [Allocation]
getAllocs = do
    contents <- readFile "src/data/allocate.txt"
    let linesOfText = lines contents
        allocs = mapMaybe readMaybe linesOfText
    length allocs `seq` return allocs
