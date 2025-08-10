module Repository.ClassroomRepository where

import Tipos
import Text.Read (readMaybe)
import Data.Maybe (mapMaybe)
import System.IO (writeFile)
import Data.List (intercalate, find, dropWhileEnd)
import Data.Char (toLower, isSpace)

-- | Normaliza o código para comparação (ignora espaços e case)
normalizeCode :: String -> String
normalizeCode = map toLower . dropWhileEnd isSpace . dropWhile isSpace

-- | Adiciona uma sala à lista de salas durante a execução do programa
-- * clssData: lista de salas atual
-- * newClassroom: nova sala a ser adicionada
saveClassroom :: [Classroom] -> Classroom -> [Classroom]
saveClassroom clssData newClassroom = clssData ++ [newClassroom]

-- | Função para escrever todas as salas em um arquivo. As turmas são geradas em tempo de execução. Elas podem ser lidas de um arquivo e alteradas ou adicionadas durante a execução do programa.
-- * classrooms: lista de salas a serem salvas
saveAllClassrooms :: [Classroom] -> IO ()
saveAllClassrooms classrooms = do
    writeFile "src/data/classroom.txt" (intercalate "\n" (map show classrooms))

-- | Busca uma sala pelo código.
-- * salas: lista de salas
-- * codigo: código da sala a ser buscado
getClassroomByCode :: [Classroom] -> String -> Maybe Classroom
getClassroomByCode salas codigo =
    let alvo = normalizeCode codigo
    in find (\sala -> normalizeCode (classroomCode sala) == alvo) salas

-- | Lê as salas de um arquivo. Converte as salas do arquivo para que as salas possam ser manipuladas durante a execução do programa.
getClassroom :: IO [Classroom]
getClassroom = do
    contents <- readFile "src/data/classroom.txt"
    let linesOfText = lines contents
        salas = mapMaybe readMaybe linesOfText
    length salas `seq` return salas -- | necessario por causa do lazy evaluation, força a leitura