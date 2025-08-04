module View.AdminView where

import Tipos
import System.IO (hFlush, stdout)
import Data.Char (toLower)
import Text.Read (readMaybe)
import Data.List.Split (splitOn)
import Repository.ClassRepository
import View.UI (drawHeader)
import View.ClassView (createClass)
import View.ProfessorView (change_requirements)
import Repository.ClassRepository (getClass, saveAllClasses)

adminMenu :: [Class] -> IO [Class]
adminMenu classes = do
    drawHeader "ADMINISTRADOR"
    putStrLn "Escolha uma opção"
    putStrLn "1. Gerar alocação"
    putStrLn "2. Cadastrar Sala"
    putStrLn "3. Cadastrar Turma"
    putStrLn "4. Editar Sala"
    putStrLn "5. Editar Turma"
    putStrLn "6. Sair e salvar"
    putStr "Opção: "
    hFlush stdout
    opcao <- getLine
    case opcao of
        --"1" -> do 
        --"2" -> do
        --"3" -> do 
        --"4" -> do
        --"5" -> do
        --"6" -> 
        _ -> do
            putStrLn "Opção inválida!"
            adminMenu classes
