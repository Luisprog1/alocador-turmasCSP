module Main (main) where

import Tipos
import Alocador
import View.ClassView
import Repository.ClassRepository
import Control.Monad (mapM_)

classroom :: Classroom
class1 :: Class
classroom = Classroom { classroomId = 1, capacity = 30, block = "Block A", resources = [Projector, Laboratory]}
class1 = Class { classId = 1, subject = "Physics", course ="Engineering", professor = "Dr. Smith", schedule = "Mon 10-12", size = 25, requirements = [Projector, Laboratory]}

getclassroomId :: Classroom -> String
getclassroomId (Classroom {block = bloco}) = bloco

getclassSubject :: Class -> String
getclassSubject (Class {subject = materia}) = materia

main :: IO ()
main = do
    putStrLn "Alocador de Turmas e Salas"
    putStrLn $ "Id da turma " ++ getclassroomId classroom
    putStrLn $ "Matéria da turma: " ++ getclassSubject class1
    putStrLn $ "Requisitos da turma: " ++ show (requirements class1)
    putStrLn $ "Recursos da sala: " ++ show (resources classroom)   
    putStrLn $ "Alocação possível: " ++ show (allocateClass class1 classroom)
    clss <- getClass
    mapM_ print clss

--    let class2 = Class { classId = 2, subject = "Chemistry", course = "Science", professor = "Dr. Jones", schedule = "Tue 14-16", size = 35, requirements = [Acessibility] }