module View.ProfessorView where

import Tipos
import Utils.Resources
import System.IO (hFlush, stdout)
import Data.Char (toLower)
import Text.Read (readMaybe)
import Data.List.Split (splitOn)
import Repository.ClassRepository
import View.UI (drawHeader, drawSubHeader)

-- | A função recebe a lista de turmas e, caso haja alterações, retorna a lista atualizada.
professorMenu :: [Class] -> Int -> IO [Class]
professorMenu clss idProfessor = do
    drawHeader "PROFESSOR"
    drawSubHeader "Por favor, escolha uma opção:"
    putStrLn "1. Visualizar turmas"
    putStrLn "2. Alterar requisitos da turma"
    putStrLn "3. Sair e salvar"
    putStr "Opção: "
    hFlush stdout
    opcao <- getLine
    -- | Para qualquer caso, a função recebe a lista que será manipulada e retorna ou um IO (se não houver alterações) ou um IO [Class] (se houver alterações).
    case opcao of
        "1" -> do
            view_allocations clss idProfessor
            putStrLn "Pressione Enter para continuar..."
            _ <- getLine
            professorMenu clss idProfessor
        "2" -> do
            clss' <- change_requirements clss 1 idProfessor
            professorMenu clss' idProfessor
        "3" -> return clss
        _   -> do
            putStrLn "Opção inválida. Tente novamente."
            professorMenu clss idProfessor

-- | Imprime as turmas do professor logado no sistema.
view_allocations :: [Class] -> Int -> IO ()
view_allocations classes id = do
    putStrLn "Carregando suas turmas..."
    let turmas = filter (\c -> id == professorId c) classes
    if null turmas
        then putStrLn $ "Nenhuma turma encontrada para o professor de matrícula " ++ show id ++ "."
        else do
            putStrLn $ "Turmas do professor " ++ show id ++ ":"
            mapM_ print turmas 

