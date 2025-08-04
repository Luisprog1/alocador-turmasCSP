module Repository.ClassroomRepository where

import Tipos
import Text.Read (readMaybe)
import Data.Maybe (mapMaybe)
import System.IO (writeFile)
import Data.List (intercalate, find)

-- | Adiciona uma sala à lista de salas durante a execução do programa
saveClassroom :: [Classroom] -> Classroom -> [Classroom]
saveClassroom clssData newClassroom = clssData ++ [newClassroom]
    
--Função para escrever todas as salas em um arquivo
--As turmas são geradas em tempo de execução. Elas podem ser lidas de um arquivo e alteradas ou adicionadas durante a execução do programa.
saveAllClassrooms :: [Classroom] -> IO ()
saveAllClassrooms classrooms = do
    writeFile "src/data/classroom.txt" (intercalate "\n" (map show classrooms))
getClassroomByCode :: [Classroom] -> String -> Maybe Classroom
getClassroomByCode salas codigo =
    find (\sala -> classroomCode sala == codigo) salas

-- | Lê as salas de um arquivo. Converte as salas do arquivo para que as salas possam ser manipuladas durante a execução do programa.
getClassroom :: IO [Classroom]
getClassroom = do
    contents <- readFile "src/data/classroom.txt"
    let linesOfText = lines contents
        salas = mapMaybe readMaybe linesOfText
    length salas `seq` return salas -- | necessario por causa do lazy evaluation, força a leitura