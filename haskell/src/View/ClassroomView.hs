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
import Utils.Error (printError)

-- | Função para criar uma nova sala. Ele recebe a lista de salas manipulada durante a execução e retorna a lista atualizada com a nova sala.
-- * clsroomData: lista de salas já persistidas
createClassRoom :: [Classroom] -> IO [Classroom]
createClassRoom clsroomData = do
    putStr "\ESC[2J"
    drawHeader "Cadastro de salas"
    putStrLn "Insira os dados da sala:"

    code <- readLine "Codigo da sala: "

    persistidas <- getClassroom
    let universo =
          clsroomData
          ++ [ s
             | s <- persistidas
             , getClassroomByCode clsroomData (classroomCode s) == Nothing
             ]

    case getClassroomByCode universo code of
      Just _  -> do
        printError "Já existe uma sala com esse código. Cadastro cancelado."
        return clsroomData
      Nothing -> do
        capacidade <- readLine "Capacidade: "

        bloco <- readLine "Bloco: "

        drawSubHeader "Adicionar recursos: "
        resources <- readResources []

        let clsroom =
              Classroom
                { classroomCode = code
                , capacity      = read capacidade :: Int
                , block         = bloco
                , resources     = resources
                , roomSchedule  = Map.empty
                }

        let classroomUpdated = saveClassroom universo clsroom
        saveAllClassrooms classroomUpdated
        putStrLn ("Sala: " ++ classroomCode clsroom ++ " cadastrada com sucesso!")
        return classroomUpdated
