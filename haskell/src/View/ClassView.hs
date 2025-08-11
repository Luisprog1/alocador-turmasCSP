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
import Text.Read (readMaybe)
import Utils.Error (printError)

-- | Função para criar uma nova turma. Ele recebe a lista de turmas manipulada durante a execução e retorna a lista atualizada com a nova turma.
-- * clssData: lista de turmas já persistidas
createClass :: [Class] -> IO [Class] 
createClass clssData = do
    putStr "\ESC[2J"
    drawHeader "Cadastro de Turmas"
    id <- return (genereteID clssData)
    putStrLn "Insira os dados da turma:"
    disciplina <- readLine "Disciplina: "
    curso <- readLine "Curso: "

    putStr "Professores Disponiveis:\n"
    users <- getUsers
    let professores = filter (\u -> userTipo u == 1) users
    setSGR [SetColor Foreground Vivid Green]
    mapM_ putStrLn [ "  -  " ++ userNome u ++ " [" ++ show (userMatricula u) ++ "]" | u <- professores ]
    setSGR [Reset]

    profIdStr <- readLine "Matrícula do professor: "
    case readMaybe profIdStr :: Maybe Int of
      Nothing -> do
        printError "Matrícula do professor inválida. Digite um número inteiro."
        createClass clssData
      Just profIdNum ->
        if any (\u -> userMatricula u == profIdNum && userTipo u == 1) professores
          then do
            drawSubHeader "Adicionar horários"
            hFlush stdout
            horario <- readSchedule []

            qtdAlunosStr <- readLine "Quantidade de alunos: "
            case readMaybe qtdAlunosStr :: Maybe Int of
              Nothing -> do
                printError "Quantidade de alunos inválida. Digite um número inteiro."
                createClass clssData
              Just qtdAlunos -> do
                drawSubHeader "Adicionar requisitos: "
                req <- readResources []

                let clss = Class
                      { classId      = id
                      , subject      = disciplina
                      , course       = curso
                      , professorId  = profIdNum
                      , schedule     = horario
                      , quantity     = qtdAlunos
                      , requirements = req
                      }
                let updateClss = saveClass clssData clss
                putStrLn ("Turma de id: " ++ show id ++ " cadastrada com sucesso!")
                -- | Retorna a lista de turmas atualizada
                return updateClss
          else do
            printError "Professor não encontrado na lista. Informe uma matrícula válida."
            createClass clssData
