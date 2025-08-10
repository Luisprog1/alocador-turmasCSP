module Repository.ClassRepository where

import Tipos
import Text.Read (readMaybe)
import Data.Maybe (mapMaybe)
import System.IO (writeFile)
import Data.List (intercalate)
import Data.Char (toLower)

-- | Adiciona uma turma à lista de turmas durante a execução do programa
-- * clssData: lista de turmas atual
-- * newClass: nova turma a ser adicionada
saveClass :: [Class] -> Class -> [Class]
saveClass clssData newClass = clssData ++ [newClass]
    
--saveClasses :: [Class] -> IO ()
--saveClasses clssData = do
    --writeFile "src/data/class.txt" (show clssData ++ "\n")

-- | Função para escrever todas as turmas em um arquivo. As turmas são geradas em tempo de execução. Elas podem ser lidas de um arquivo e alteradas ou adicionadas durante a execução do programa.
-- * classes: lista de turmas a serem salvas
saveAllClasses :: [Class] -> IO ()
saveAllClasses classes = do
    writeFile "src/data/class.txt" (intercalate "\n" (map show classes))

-- | Lê as turmas de um arquivo. Converte as turmas do arquivo para que as turmas possam ser manipuladas durante a execução do programa.
getClass :: IO [Class]
getClass = do
    contents <- readFile "src/data/class.txt"
    let linesOfText = lines contents
        turmas = mapMaybe readMaybe linesOfText
    length turmas `seq` return turmas



-- | Gera um ID único para uma nova turma. Ele pega o maior ID existente e adiciona 1.
genereteID :: [Class] -> Int
genereteID classes = if null classes then 1 else maximum (map classId classes) + 1