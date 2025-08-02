module Repository.ClassRepository where

import Tipos
import Text.Read (readMaybe)
import Data.Maybe (mapMaybe)
import System.IO (writeFile)
import Data.List (intercalate)
import Data.Char (toLower)

-- Adiciona uma turma à lista de turmas durante a execução do programa
saveClass :: [Class] -> Class -> [Class]
saveClass clssData newClass = clssData ++ [newClass]
    
--saveClasses :: [Class] -> IO ()
--saveClasses clssData = do
    --writeFile "src/data/class.txt" (show clssData ++ "\n")

--Função para escrever todas as turmas em um arquivo
--As turmas são geradas em tempo de execução. Elas podem ser lidas de um arquivo e alteradas ou adicionadas durante a execução do programa.
saveAllClasses :: [Class] -> IO ()
saveAllClasses classes = do
    writeFile "src/data/class.txt" (intercalate "\n" (map show classes))

-- Lê as turmas de um arquivo. Converte as turmas do arquivo para que as turmas possam ser manipuladas durante a execução do programa.
getClass :: IO [Class]
getClass = do
    contents <- readFile "src/data/class.txt"
    let linesOfText = lines contents
    return $ mapMaybe readMaybe linesOfText

-- Função auxiliar para converter uma string em um recurso. Funciona para a entrada do usuário quando ele digita os recursos (String) e precisa ser convertida para o tipo Resource.
-- Funciona para Salas e Turmas.
parseResource :: String -> Resource
parseResource str = case map toLower str of
  "projector"     -> Projector
  "laboratory"    -> Laboratory
  "acessibility"  -> Acessibility
  _ -> Other str