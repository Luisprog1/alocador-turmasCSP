module View.ClassView () where

import Tipos    
import Repository.ClassRepository
import System.IO (hFlush, stdout)
import Data.Char (toLower)
import Data.List.Split (splitOn)

createClass :: IO ()
createClass = do
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
    let recursos = map parseResource (splitOn " ," line)
    let clss = Class {classId = 0 ,subject = disciplina, course = curso, professor = professor, schedule = horario, size = read qtdAlunos :: Int, requirements = recursos}
    saveClass clss
    putStrLn "Turma cadastrada com sucesso!"

parseResource :: String -> Resource
parseResource str = case map toLower str of
  "projector"     -> Projector
  "laboratory"    -> Laboratory
  "acessibility"  -> Acessibility