module View.ClassView where

import Tipos    
import Repository.ClassRepository 
import System.IO (hFlush, stdout)
import Data.List.Split (splitOn)
import Utils.Resources
import View.UI (drawHeader)
import Utils.Schedule
import View.UI 
import Repository.UserRepository
import System.Console.ANSI

-- | Função para criar uma nova turma. Ele recebe a lista de turmas manipulada durante a execução e retorna a lista atualizada com a nova turma.
createClass :: [Class] -> IO [Class] 
createClass clssData = do
    putStr "\ESC[2J"
    drawHeader "Cadastro de Turmas"
    id <- return (genereteID clssData)
    putStrLn "Insira os dados da turma:"
    putStr "Disciplina: "
    hFlush stdout
    disciplina <- getLine
    putStr "Curso: "
    hFlush stdout
    curso <- getLine

    putStr "Professores Disponiveis:\n"
    users <- getUsers
    let professores = filter (\u -> userTipo u == 1) users
    setSGR [SetColor Foreground Vivid Green]
    mapM_ putStrLn [ "  -  " ++ userNome u ++ " [" ++ show (userMatricula u) ++ "]" | u <- professores ]
    setSGR [Reset]

    putStr "Professor: "
    hFlush stdout
    profId <- getLine

    drawSubHeader "Adicionar horários"
    hFlush stdout
    horario <- readSchedule []

    putStr "Quantidade de alunos: "
    hFlush stdout
    qtdAlunos <- getLine

    drawSubHeader "Adicionar requisitos: "
    req <- readResources []

    let clss = Class {classId = id ,subject = disciplina, course = curso, professorId = read profId, schedule = horario, quantity = read qtdAlunos :: Int, requirements = req}
    let updateClss = saveClass clssData clss
    putStrLn ("Turma de id: " ++ show id ++ " cadastrada com sucesso!")
    -- | Retorna a lista de turmas atualizada
    return updateClss
