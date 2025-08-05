module View.ClassroomView where
import Utils.Resources
import Tipos    
import Repository.ClassroomRepository 
import Repository.ClassRepository 
import qualified Data.Map as Map

import System.IO (hFlush, stdout)
import Data.List.Split (splitOn)

-- | Função para criar uma nova sala. Ele recebe a lista de salas manipulada durante a execução e retorna a lista atualizada com a nova sala.
createClassRoom :: [Classroom] -> IO [Classroom] 
createClassRoom clsroomData = do
    putStr "\ESC[2J"
    putStrLn "=================================="
    putStrLn "       Cadastro de salas"
    putStrLn "=================================="
    putStrLn "Insira os dados da sala:"
    putStr "Codigo da sala: "
    hFlush stdout
    code <- getLine
    putStr "Capacidade: "
    hFlush stdout
    capacidade <- getLine
    putStr "Bloco: "
    hFlush stdout
    bloco <- getLine
    putStr "Recursos Disponiveis (digite os recursos separados por virgula, ex: Projector, Laboratory): "
    hFlush stdout
    line <- getLine
    let recursos = map parseResource (splitOn ", " line)
    let clsroom = Classroom {classroomCode = code , capacity = read capacidade :: Int, block = bloco, resources = recursos, roomSchedule = Map.empty}
    let classroomUpdated = saveClassroom clsroomData clsroom
    putStrLn ("Sala: " ++ show (classroomCode clsroom) ++ " cadastrada com sucesso!")
    return classroomUpdated
