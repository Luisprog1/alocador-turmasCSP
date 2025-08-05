module Main (main) where

import Tipos
import Utils.Schedule
import Utils.Alocate
import View.ClassView 
import Repository.ClassRepository -- getClass
import Repository.ClassroomRepository-- getClassrooms
import View.ClassroomView
import Repository.ClassroomRepository
import Control.Monad ()
import View.ProfessorView
import Data.Map as Map
import View.RegisterView (userScreen)
import View.UI (drawHeader)

classroom :: Classroom
class1 :: Class
classroom = Classroom { classroomCode = "CD105", capacity = 30, block = "Block C", resources = [Projector, Laboratory],
roomSchedule = Map.fromList
    [ (Monday, [1, 2, 3, 4])
    , (Tuesday,   [1, 2, 3, 4])
    , (Wednesday,  [5, 6])
    ]}

class1 = Class { classId = 1, subject = "Physics", course ="Engineering", professor = "Dr. Smith", schedule = [(Monday, 6), (Monday, 5)], quantity = 25, requirements = [Projector, Laboratory]}

getclassroomCode :: Classroom -> String
getclassroomCode (Classroom {classroomCode = code}) = code

getclassSubject :: Class -> String
getclassSubject (Class {subject = materia}) = materia

type AllocationSolution = Maybe [Allocation]

main :: IO ()
main = do
    -- | let newClassr = addOccupation class1 classroom
    -- | putStrLn "Alocador de Turmas e Salas"
    -- | putStrLn $ "Id da turma " ++ getclassroomId classroom
    -- | putStrLn $ "Matéria da turma: " ++ getclassSubject class1
    -- | putStrLn $ "Requisitos da turma: " ++ show (requirements class1)
    -- | putStrLn $ "Recursos da sala: " ++ show (resources classroom)  
    -- | putStrLn $ "Horarios da sala: " ++ show (roomSchedule newClassr)    
    -- | putStrLn $ "Alocação possível: " ++ show (allocateClass class1 classroom)
    -- | clss <- getClass
    -- | clss' <- createClass clss
    -- | putStrLn "Carregando turmas..."
    -- | -- | A função welcome_screen recebe a lista de turmas e retorna a lista atualizada com as alterações feitas pelo usuário.
    -- | -- | Como não é possivel alterar a propria clss, é preciso criar uma nova variável clss' para receber o retorno da função (a lista atualizada).
    -- | clss'' <- welcome_screen clss'
    -- | -- | Ao final da execução sempre rodar a função saveAllClasses para salvar no arquivo as turmas atualizadas ou adicionadas. O mesmo deverá ser feito para as salas e as alocações quando prontas.
    -- | saveAllClasses clss''
    -- | putStrLn "Salvando turmas..."
    --clss <- getClass
    --classrooms <- getClassroom
    --mapM print clss
    --mapM print classrooms
    --let emptyRooms = resetClassrooms classrooms
    --let (allocationResult, finalId, newClassrooms) = backtrackAllocate 1 clss emptyRooms
    --saveAllClassrooms newClassrooms
    --case allocationResult of
        --Right allocations -> do
            --mapM_ print allocations
                --saveAllAllocations allocations -- |Salva as alocações em um arquivo COMENTÁRIO
                --putStrLn $ "\nPróximo ID de alocação disponível: " ++ show finalId COMENTÁRIO
        --Left conflictCls -> do
            --putStrLn $ "Conflito encontrado com a turma: " ++ show (classId conflictCls)
    userScreen
