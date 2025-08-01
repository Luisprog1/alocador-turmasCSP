module View.ClassView where

import Tipos    
import Repository.ClassRepository (saveClass)
import System.IO (hFlush, stdout)
import Data.List.Split (splitOn)

createClass :: [Class] -> IO [Class] 
createClass clssData = do
    putStr "\ESC[2J"
    putStrLn "=================================="
    putStrLn "       Cadastro de Sala de Aula"
    putStrLn "=================================="
    putStrLn "Insira os dados da turma:"
    putStr "Disciplina: "
    hFlush stdout
    disciplina <- getLine
    putStr "Curso: "
    hFlush stdout
    curso <- getLine
    putStr "Professor: "
    hFlush stdout
    professor <- getLine
    putStr "Horário: "
    hFlush stdout
    horario <- getLine
    putStr "Quantidade de docentes: "
    hFlush stdout
    qtdAlunos <- getLine
    putStr "Recursos necessário (digite os recursos separados por virgula, ex: Projector, Laboratory): "
    hFlush stdout
    line <- getLine
    let recursos = map parseResource (splitOn ", " line)
    let clss = Class {classId = 0 ,subject = disciplina, course = curso, professor = professor, schedule = [(Monday, 5)], quantity = read qtdAlunos :: Int, requirements = recursos}
    let updateClss = saveClass clssData clss
    putStrLn "Turma cadastrada com sucesso!"
    return updateClss
