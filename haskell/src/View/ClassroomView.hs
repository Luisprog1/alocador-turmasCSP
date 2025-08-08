module View.ClassroomView where
import Utils.Resources
import Tipos    
import Repository.ClassroomRepository 
import Repository.ClassRepository 
import qualified Data.Map as Map
import View.UI
import System.IO (hFlush, stdout)
import Data.List.Split (splitOn)
import View.UI (drawHeader)

-- | Função para criar uma nova sala. Ele recebe a lista de salas manipulada durante a execução e retorna a lista atualizada com a nova sala.
createClassRoom :: [Classroom] -> IO [Classroom] 
createClassRoom clsroomData = do
    putStr "\ESC[2J"
    drawHeader "Cadastro de salas"
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
    drawSubHeader "Adicionar recursos: "
    resources <- readResources []
    let clsroom = Classroom {classroomCode = code , capacity = read capacidade :: Int, block = bloco, resources = resources, roomSchedule = Map.empty}
    let classroomUpdated = saveClassroom clsroomData clsroom
    putStrLn ("Sala: " ++ show (classroomCode clsroom) ++ " cadastrada com sucesso!")
    return classroomUpdated
