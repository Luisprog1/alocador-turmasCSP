module View.ProfessorView where

import Tipos
import Utils.AddResources
import System.IO (hFlush, stdout)
import Data.Char (toLower)
import Text.Read (readMaybe)
import Data.List.Split (splitOn)
import Repository.ClassRepository
import View.UI (drawHeader)

-- | A função recebe a lista de turmas e, caso haja alterações, retorna a lista atualizada.
professorMenu :: [Class] -> Int -> IO [Class]
professorMenu clss idProfessor = do
    drawHeader "PROFESSOR"
    putStrLn "Por favor, escolha uma opção:"
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
            clss' <- change_requirements clss
            professorMenu clss' idProfessor
        "3" -> return clss
        _   -> do
            putStrLn "Opção inválida. Tente novamente."
            professorMenu clss idProfessor

-- | Imprime as turmas do professor logado.
view_allocations :: [Class] -> Int -> IO ()
view_allocations clss id = do
    putStrLn "Carregando suas turmas..."
    let turmas = filter (\c -> id == professorId c) clss
    if null turmas
        then putStrLn $ "Nenhuma turma encontrada para o professor de matrícula " ++ show id ++ "."
        else do
            putStrLn $ "Turmas do professor " ++ show id ++ ":"
            mapM_ print turmas -- | Aqui você deve implementar a lógica para buscar as alocações do professor

-- | Função para alterar os requisitos de uma turma. Ela recebe a lista de turmas e retorna a lista atualizada com os requisitos alterados.
change_requirements :: [Class] -> IO [Class]
change_requirements clss = do
    putStrLn "Informe o ID da turma:"
    hFlush stdout
    turmaId <- getLine
    case readMaybe turmaId :: Maybe Int of
        Nothing -> do
            putStrLn "ID inválido. Insira um ID numérico válido."
            change_requirements clss
        Just turmaIdInt -> do
            putStrLn "Informe os novos requisitos (separados por vírgula, ex: Projector, Laboratory):"
            hFlush stdout
            requisitos <- getLine
            --Transforma os requisitos (String) no tipo Resource. DEFINIÇÃO DO PARSERESOURCE NO ARQUIVO ClassRepository.hs
            let novosRequisitos = map parseResource (splitOn ", " requisitos)
            putStrLn "Alterando requisitos da turma..."
            let clss' = map (\c -> if classId c == turmaIdInt then c { requirements = novosRequisitos } else c) clss
            putStrLn "Requisitos da turma alterados com sucesso na memória."
            return clss'
