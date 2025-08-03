module Main (main) where

import Tipos ( Classroom(..), Class(..), Resource(Laboratory, Projector), Weekend(..), addOccupation )
import Alocador ( allocateClass )
import View.ClassView 
import Repository.ClassRepository
import Control.Monad ()
import View.ProfessorView
import Data.Map as Map
import View.RegisterView (register_screen, login_screen) 

classroom :: Classroom
class1 :: Class
classroom = Classroom { classroomId = 1, capacity = 30, block = "Block A", resources = [Projector, Laboratory],
roomSchedule = Map.fromList
    [ (Monday, [1, 2, 3, 4])
    , (Tuesday,   [1, 2, 3, 4])
    , (Wednesday,  [5, 6])
    ]}

class1 = Class { classId = 1, subject = "Physics", course ="Engineering", professor = "Dr. Smith", schedule = [(Monday, 6), (Monday, 5)], quantity = 25, requirements = [Projector, Laboratory]}

getclassroomId :: Classroom -> String
getclassroomId (Classroom {block = bloco}) = bloco

getclassSubject :: Class -> String
getclassSubject (Class {subject = materia}) = materia

main :: IO ()
main = do
    -- let newClassr = addOccupation class1 classroom
    -- putStrLn "Alocador de Turmas e Salas"
    -- putStrLn $ "Id da turma " ++ getclassroomId classroom
    -- putStrLn $ "Matéria da turma: " ++ getclassSubject class1
    -- putStrLn $ "Requisitos da turma: " ++ show (requirements class1)
    -- putStrLn $ "Recursos da sala: " ++ show (resources classroom)  
    -- putStrLn $ "Horarios da sala: " ++ show (roomSchedule newClassr)    
    -- putStrLn $ "Alocação possível: " ++ show (allocateClass class1 classroom)
    -- clss <- getClass
    -- clss' <- createClass clss
    -- putStrLn "Carregando turmas..."
    -- -- A função welcome_screen recebe a lista de turmas e retorna a lista atualizada com as alterações feitas pelo usuário.
    -- -- Como não é possivel alterar a propria clss, é preciso criar uma nova variável clss' para receber o retorno da função (a lista atualizada).
    -- clss'' <- welcome_screen clss'
    -- -- Ao final da execução sempre rodar a função saveAllClasses para salvar no arquivo as turmas atualizadas ou adicionadas. O mesmo deverá ser feito para as salas e as alocações quando prontas.
    -- saveAllClasses clss''
    -- putStrLn "Salvando turmas..."
    putStrLn "1 - Register"
    putStrLn "2 - Login"
    option <- getLine
    case option of
        "1" -> register_screen
        "2" -> login_screen
        _   -> putStrLn "Invalid option"